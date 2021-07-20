import { deployContract } from "ethereum-waffle";
import PilotArtifact from "../artifacts/contracts/Pilot.sol/Pilot.json";
import { Contract } from "ethers";

export async function deployPilot(deployer: any): Promise<any> {
  const pilot = await deployContract(deployer, PilotArtifact);
}
