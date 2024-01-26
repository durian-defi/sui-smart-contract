module spool::spool {

	use sui::coin::{Self, Coin};
  use sui::event;
	use sui::object::{Self, UID};
  use sui::sui::SUI;
	use sui::tx_context::{Self, TxContext};
	use sui::transfer;
	use sui::vec_map::{Self, VecMap};
	
	use stsui::stsui::{STSUI};

	const ERROR_NOT_STAKE: u64 = 0;
	const ERROR_INSUFFICIENT_BALANCE: u64 = 1;
  const ERROR_NOT_VALID_AMOUNT: u64 = 2;
  const ERROR_AMOUNT_CANNOT_BE_ZERO: u64 = 3;

	struct SPoolAdminCap has key {
		id: UID
	}

	struct UserStake has store, drop {
    amount: u64
	}

	struct SPoolStorage has key { 
		id: UID,
    wallet: address,
		users: VecMap<address, UserStake>
	}

	// event
	struct StakeEvent has copy, drop {
    user_address: address,
    amount: u64,
  }

	struct UnstakeEvent has copy, drop {
    user_address: address,
    amount: u64,
  }

	fun init(ctx: &mut TxContext) {
		let sender = tx_context::sender(ctx);
		transfer::transfer(
			SPoolAdminCap {
				id: object::new(ctx)
			},
			sender
		);
		transfer::share_object(
			SPoolStorage {
				id: object::new(ctx),
        wallet: @0xe06253834ecad640e41d422a1b2fcf3b17fe0beb881b16c42782f9f87c6ca775,
				users: vec_map::empty()
			}
		);
	}

	public entry fun stake(
    storage: &mut SPoolStorage, 
    coins: Coin<STSUI>,
    ctx: &mut TxContext
  ) {
    let sender = tx_context::sender(ctx);
    let amount = coin::value(&coins);
    assert!(amount > 0, ERROR_AMOUNT_CANNOT_BE_ZERO);
    transfer::public_transfer<Coin<STSUI>>(coins, storage.wallet);
    if (!vec_map::contains(&storage.users, &sender)) {
      let new_user_stake = UserStake {
        amount
      };
      vec_map::insert(&mut storage.users, sender, new_user_stake);

    } else {
      let user_stake = vec_map::get_mut(&mut storage.users, &sender);
      user_stake.amount = user_stake.amount + amount;
    };
    event::emit(StakeEvent {
			user_address: sender, 
			amount: amount,
		});
  }

  public entry fun transfer_ownership(admin_cap: SPoolAdminCap, new_owner: address){
    transfer::transfer(admin_cap, new_owner)
  }

  public entry fun update_wallet(_: &mut SPoolAdminCap, storage: &mut SPoolStorage, new_wallet: address){
    storage.wallet = new_wallet;
  }
}