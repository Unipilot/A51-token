// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "./interfaces/IPilot.sol";

contract Pilot is IPilot, AccessControl {
  address private constant FOUNDATION = 0xAfA13aa8F1b1d89454369c28b0CE1811961A7907;

  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  string public constant name = "Pilot Token";

  string public constant symbol = "PILOT";

  uint8 public constant decimals = 18;

  uint256 public totalSupply;

  modifier onlyMinter {
    require(hasRole(MINTER_ROLE, msg.sender), "PILOT :: NOT_MINTER");
    _;
  }

  mapping(address => uint256) public balanceOf;

  mapping(address => mapping(address => uint256)) public allowances;

  constructor(address _timelock) public {
    _mint(FOUNDATION, 20000000000000000000000000);
    _setupRole(MINTER_ROLE, _timelock);
  }

  function _mint(address to, uint256 value) internal {
    totalSupply = totalSupply + value;
    balanceOf[to] = balanceOf[to] + value;
    emit Transfer(address(0), to, value);
  }

  function _burn(address from, uint256 value) internal {
    balanceOf[from] = balanceOf[from] - value;
    totalSupply = totalSupply - value;
    emit Transfer(from, address(0), value);
  }

  function _approve(
    address owner,
    address spender,
    uint256 value
  ) private {
    allowances[owner][spender] = value;
    emit Approval(owner, spender, value);
  }

  function _transfer(
    address from,
    address to,
    uint256 value
  ) private {
    require(to != address(this) && to != address(0), "PILOT:: INVALID_RECIEVER_ADDRESS");
    balanceOf[from] = balanceOf[from] - value;
    balanceOf[to] = balanceOf[to] + value;
    emit Transfer(from, to, value);
  }

  function mint(address to, uint256 value) external override onlyMinter returns (bool) {
    _mint(to, value);
    return true;
  }

  function burn(uint256 value) external override returns (bool) {
    _burn(msg.sender, value);
    return true;
  }

  function burnFrom(address account, uint256 amount) external override {
    uint256 currentAllowance = allowance(account, msg.sender);
    require(currentAllowance >= amount, "PILOT: BURN_AMOUNT_EXCEEDS_ALLOWANCE");
    _approve(account, msg.sender, currentAllowance - amount);
    _burn(account, amount);
  }

  function approve(address spender, uint256 value) external override returns (bool) {
    _approve(msg.sender, spender, value);
    return true;
  }

  function allowance(address owner, address spender) public view override returns (uint256) {
    return allowances[owner][spender];
  }

  function transfer(address to, uint256 value) external override returns (bool) {
    _transfer(msg.sender, to, value);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external override returns (bool) {
    uint256 fromAllowance = allowances[from][msg.sender];
    if (fromAllowance != type(uint256).max) {
      allowances[from][msg.sender] = fromAllowance - value;
    }
    _transfer(from, to, value);
    return true;
  }
}
