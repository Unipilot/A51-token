import { use } from "chai";
import { solidity } from "ethereum-waffle";
import { deployPilot } from "./stubs";
import hre from "hardhat";
import { Contract } from "ethers";
import { shouldBehaveLikePilotFunctions } from "./PilotFunctions/pilotFunctions.behavior";

use(solidity);

describe("Initiating Test Suite", async () => {
  let pilotToken: Contract;
  const [wallet0, wallet1] = await hre.ethers.getSigners();

  before("Calling the functions", async () => {
    pilotToken = await deployPilot(wallet0, wallet0);
  });

  describe("Running the contract functions", async () => {
    it("Runs the pilot functions", async () => {
      await shouldBehaveLikePilotFunctions(pilotToken, wallet0, wallet1);
    });
  });
});
