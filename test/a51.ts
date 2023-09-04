import hre from "hardhat";
import { use } from "chai";
import { Contract } from "ethers";
import { solidity } from "ethereum-waffle";
import { deployA51 } from "./stubs";
import { shouldBehaveLikeA51Functions } from "./A51Functions/a51Functions.behavior";

use(solidity);

describe("Initiating Test Suite", async () => {
  let a51Token: Contract;

  beforeEach("Calling the functions", async () => {
    const [wallet0, wallet1] = await hre.ethers.getSigners();

    a51Token = await deployA51(wallet0, wallet0);
  });

  describe("Running the contract functions", async () => {
    it("Runs the A51 functions", async () => {
      const [wallet0, wallet1] = await hre.ethers.getSigners();

      await shouldBehaveLikeA51Functions(a51Token, wallet0, wallet1);
    });
  });
});
