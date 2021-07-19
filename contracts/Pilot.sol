// SPDX-License-Identifier: MIT

pragma solidity >=0.8.6;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Pilot is ERC20Burnable {
  address public timelock;

  address private _minter;

  address public constant FOUNDATION = 0xAfA13aa8F1b1d89454369c28b0CE1811961A7907;

  // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
  bytes32 private constant EIP712DOMAIN_HASH =
    0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;

  // bytes32 private constant NAME_HASH = keccak256("Pilot")
  bytes32 private constant NAME_HASH =
    0xbf5bd13a20f5bf0800ee2089e53a178ed2e5611e9703c242c63c882c6ab831d6;

  // bytes32 private constant VERSION_HASH = keccak256("1")
  bytes32 private constant VERSION_HASH =
    0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;

  // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
  bytes32 public constant PERMIT_TYPEHASH =
    0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

  // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
  bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
    0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;

  modifier onlyMinter {
    require(msg.sender == _minter, "PILOT:: NOT_MINTER");
    _;
  }

  modifier onlyTimelock {
    require(msg.sender == timelock, "PILOT:: NOT_TIMELOCK");
    _;
  }

  mapping(address => uint256) public nonces;

  mapping(address => mapping(bytes32 => bool)) public authorizationState;

  event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);

  constructor(address _timelock) ERC20("Unipilot", "PILOT") {
    _mint(FOUNDATION, 20000000000000000000000000);
    timelock = _timelock;
  }

  function mint(address to, uint256 value) external onlyMinter returns (bool) {
    _mint(to, value);
    return true;
  }

  function updateMinter(address newMinter) external onlyTimelock {
    require(newMinter != address(0), "PILOT:: INVALID_MINTER_ADDRESS");
    _minter = newMinter;
  }

  function _validateSignedData(
    address signer,
    bytes32 encodeData,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) internal view {
    bytes32 digest = keccak256(abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData));
    address recoveredAddress = ecrecover(digest, v, r, s);
    require(
      recoveredAddress != address(0) && recoveredAddress == signer,
      "PILOT:: INVALID_SIGNATURE"
    );
  }

  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external {
    require(deadline >= block.timestamp, "PILOT:: AUTH_EXPIRED");

    bytes32 encodeData =
      keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));
    nonces[owner] = nonces[owner] + 1;
    _validateSignedData(owner, encodeData, v, r, s);
    _approve(owner, spender, value);
  }

  function getDomainSeparator() public view returns (bytes32) {
    return
      keccak256(
        abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this))
      );
  }

  function getChainId() public view returns (uint256 chainId) {
    assembly {
      chainId := chainid()
    }
  }

  function transferWithAuthorization(
    address from,
    address to,
    uint256 value,
    uint256 validAfter,
    uint256 validBefore,
    bytes32 nonce,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external {
    require(block.timestamp > validAfter, "PILOT:: AUTH_NOT_YET_VALID");
    require(block.timestamp < validBefore, "PILOT:: AUTH_EXPIRED");
    require(!authorizationState[from][nonce], "PILOT:: AUTH_ALREADY_USED");

    bytes32 encodeData =
      keccak256(
        abi.encode(
          TRANSFER_WITH_AUTHORIZATION_TYPEHASH,
          from,
          to,
          value,
          validAfter,
          validBefore,
          nonce
        )
      );
    _validateSignedData(from, encodeData, v, r, s);

    authorizationState[from][nonce] = true;
    emit AuthorizationUsed(from, nonce);

    _transfer(from, to, value);
  }
}
