import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber, Contract } from "ethers";
import {
  defaultAbiCoder,
  hexlify,
  keccak256,
  toUtf8Bytes,
  solidityPack,
  parseUnits,
} from "ethers/lib/utils";

export async function shouldBehaveLikePilotFunctions(
  pilotToken: Contract,
  wallet0: SignerWithAddress,
  wallet1: SignerWithAddress,
): Promise<void> {
  const NAME_HASH: string = "0x96f8699b9d60ee03e2ae096e7ed75448335015f6b0f67e4f1540d650607f9ed9";
  const VERSION_HASH: string = "0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6";
  const EIP712DOMAIN_HASH: string =
    "0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f";
  describe("PILOT FUNCTIONS", async () => {
    it("Validates the name of token", async () => {
      expect(await pilotToken.name()).to.be.equal("Unipilot");
    });

    it("Validates the symbol of token", async () => {
      expect(await pilotToken.symbol()).to.be.equal("PILOT");
    });

    it("Validates the decimal of token", async () => {
      expect(await pilotToken.decimals()).to.be.equal(18);
    });

    it("Validates total supply after mint", async () => {
      expect(await pilotToken.totalSupply()).to.be.equal(parseUnits("20005000", "18"));
    });

    it("Validates name hash", async () => {
      expect(keccak256(toUtf8Bytes("Unipilot"))).to.be.equal(NAME_HASH);
    });

    it("Validates version hash", async () => {
      expect(keccak256(toUtf8Bytes("1"))).to.be.equal(VERSION_HASH);
    });

    it("Validates domain seperator", async () => {
      expect(await pilotToken.getDomainSeparator()).to.be.equal(
        keccak256(
          defaultAbiCoder.encode(
            ["bytes32", "bytes32", "bytes32", "uint256", "address"],
            [
              EIP712DOMAIN_HASH,
              NAME_HASH,
              VERSION_HASH,
              await pilotToken.getChainId(),
              pilotToken.address,
            ],
          ),
        ),
      );
    });

    it("Approves the tokens", async () => {
      await pilotToken.approve(wallet1.address, parseUnits("2000", "18"));
      expect(await pilotToken.allowance(wallet0.address, wallet1.address)).to.be.equal(
        parseUnits("2000", "18"),
      );
    });
  });
}
