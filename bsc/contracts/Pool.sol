//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Pool is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  event Stake(address indexed user, uint256 amount);

  address public recipient;
  IERC20 public token;

  address[] public stakingAddresses;
  mapping(address => uint) public stakingBalance;

  constructor() Ownable() {}

  function setInfo(address _token, address _recipient) public onlyOwner  {
    token = IERC20(_token);
    recipient = _recipient;
  }

  function stake(uint _amount) public {
    require(
      _amount > 0,
      "USDT amount is not valid"
    );

		token.transferFrom(_msgSender(), recipient, _amount);

		if(stakingBalance[_msgSender()] == 0) {
			stakingAddresses.push(_msgSender());
		}

		stakingBalance[_msgSender()] = stakingBalance[_msgSender()] + _amount;
	}
}
