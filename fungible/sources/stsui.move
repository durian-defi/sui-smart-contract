// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module stsui::stsui {
	use std::option;
	use sui::coin::{Self, Coin, TreasuryCap};
	use sui::transfer;
	use sui::tx_context::{Self, TxContext};
	use sui::url;

	// Name of the coin. By convention, this type has the same name as its parent module
	// and has no fields. The full type of the coin defined by this module will be `COIN<MANAGED>`.
	struct STSUI has drop {}

	// For when empty vector is supplied into join function.
	const ENoCoins: u64 = 0;
	const MINT_AMOUNT: u64 = 112_000_000_000_000_000;

	const TOKEN_SYMBOL: vector<u8> = b"stSUI";
	const TOKEN_NAME: vector<u8> = b"stSUI";
	const TOKEN_DESCRIPTION: vector<u8> = b"";
	const TOKEN_URL: vector<u8> = b"";


	fun init(witness: STSUI, ctx: &mut TxContext) {
		let owner = tx_context::sender(ctx);
		let (treasury_cap, metadata) = coin::create_currency<STSUI>(witness, 9, TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DESCRIPTION,  option::some(url::new_unsafe_from_bytes(TOKEN_URL)), ctx);
		transfer::public_freeze_object(metadata);
		mint(&mut treasury_cap, MINT_AMOUNT, owner, ctx);
		transfer::public_transfer(treasury_cap, tx_context::sender(ctx));

	}

	public entry fun mint(
		treasury_cap: &mut TreasuryCap<STSUI>, amount: u64, recipient: address, ctx: &mut TxContext
	) {
		coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
	}

	public entry fun burn(treasury_cap: &mut TreasuryCap<STSUI>, coin: Coin<STSUI>) {
		coin::burn(treasury_cap, coin);
	}

	public entry fun transfer_ownership(treasury_cap: TreasuryCap<STSUI>, new_owner: address){
		transfer::public_transfer(treasury_cap, new_owner)
	}

}