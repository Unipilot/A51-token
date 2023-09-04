// SPDX-License-Identifier: MIT

pragma solidity >=0.8.6;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract A51 is ERC20Burnable {
  // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
  bytes32 private constant EIP712DOMAIN_HASH =
    0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;

  // bytes32 private constant NAME_HASH = keccak256("A51 Finance")
  bytes32 private constant NAME_HASH =
    0xeed86f35eb32621166cf710ebac5b1112c4c3da551f8dd7e468715ac520be5e0;

  // bytes32 private constant VERSION_HASH = keccak256("1")
  bytes32 private constant VERSION_HASH =
    0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;

  // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
  bytes32 public constant PERMIT_TYPEHASH =
    0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

  // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
  bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
    0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;

  mapping(address => uint256) public nonces;

  mapping(address => mapping(bytes32 => bool)) public authorizationState;

  event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);

  constructor(address[] memory accounts, uint256[] memory amounts) ERC20("A51 Finance", "A51") {
    _mintToWallets(accounts, amounts);
  }

  function _mintToWallets(address[] memory _accounts, uint256[] memory _amounts) internal {
    for (uint256 i = 0; i < _accounts.length; i++) {
      _mint(_accounts[i], _amounts[i]);
    }
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
      "A51:: INVALID_SIGNATURE"
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
    require(deadline >= block.timestamp, "A51:: AUTH_EXPIRED");

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
    require(block.timestamp < validBefore, "A51:: AUTH_EXPIRED");
    require(block.timestamp > validAfter, "A51:: AUTH_NOT_YET_VALID");
    require(!authorizationState[from][nonce], "A51:: AUTH_ALREADY_USED");

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
