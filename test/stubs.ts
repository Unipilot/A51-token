import { deployContract } from "ethereum-waffle";
import PilotArtifact from "../artifacts/contracts/Pilot.sol/Pilot.json";
import { BigNumber, Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { parseUnits } from "ethers/lib/utils";

export async function deployPilot(deployer: any, wallet0: SignerWithAddress): Promise<any> {
  const pilot = await deployContract(deployer, PilotArtifact, [
    wallet0.address,
    [wallet0.address],
    [parseUnits("5000", "18")],
  ]);
  return pilot;
}
