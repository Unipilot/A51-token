import { expect } from "chai";
import { Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

import {
  defaultAbiCoder,
  keccak256,
  toUtf8Bytes,
  parseUnits,
} from "ethers/lib/utils";

export async function shouldBehaveLikeA51Functions(
  a51Token: Contract,
  wallet0: SignerWithAddress,
  wallet1: SignerWithAddress,
): Promise<void> {
  const NAME_HASH: string = "0xeed86f35eb32621166cf710ebac5b1112c4c3da551f8dd7e468715ac520be5e0";
  const VERSION_HASH: string = "0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6";
  const EIP712DOMAIN_HASH: string =
    "0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f";
  describe("A51 FUNCTIONS", async () => {
    it("Validates the name of token", async () => {
      expect(await a51Token.name()).to.be.equal("A51 Finance");
    });

    it("Validates the symbol of token", async () => {
      expect(await a51Token.symbol()).to.be.equal("A51");
    });

    it("Validates the decimal of token", async () => {
      expect(await a51Token.decimals()).to.be.equal(18);
    });

    it("Validates total supply after mint", async () => {
      expect(await a51Token.totalSupply()).to.be.equal(parseUnits("5000", "18"));
    });

    it("Validates total supply after burn", async () => {
      await a51Token.burn(parseUnits("1000", "18"));

      expect(await a51Token.totalSupply()).to.be.equal(parseUnits("4000", "18"));
    });

    it("Validates name hash", async () => {
      expect(keccak256(toUtf8Bytes("A51 Finance"))).to.be.equal(NAME_HASH);
    });

    it("Validates version hash", async () => {
      expect(keccak256(toUtf8Bytes("1"))).to.be.equal(VERSION_HASH);
    });

    it("Validates domain seperator", async () => {
      expect(await a51Token.getDomainSeparator()).to.be.equal(
        keccak256(
          defaultAbiCoder.encode(
            ["bytes32", "bytes32", "bytes32", "uint256", "address"],
            [
              EIP712DOMAIN_HASH,
              NAME_HASH,
              VERSION_HASH,
              await a51Token.getChainId(),
              a51Token.address,
            ],
          ),
        ),
      );
    });

    it("Approves the tokens", async () => {
      await a51Token.approve(wallet1.address, parseUnits("2000", "18"));
      expect(await a51Token.allowance(wallet0.address, wallet1.address)).to.be.equal(
        parseUnits("2000", "18"),
      );
    });
  });
}
