pragma solidity >=0.8.6;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPilot {
  function mint(address to, uint256 value) external returns (bool);

  function burn(uint256 value) external returns (bool);

  function burnFrom(address account, uint256 amount) external;

  function approve(address spender, uint256 value) external returns (bool);

  function allowance(address owner, address spender) external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  event Transfer(address sender, address reciever, uint256 amount);

  event Approval(address owner, address spender, uint256 amount);
}
