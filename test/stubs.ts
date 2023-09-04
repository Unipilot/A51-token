import { parseUnits } from "ethers/lib/utils";
import { deployContract } from "ethereum-waffle";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

import A51Artifact from "../artifacts/contracts/A51.sol/A51.json";

export async function deployA51(deployer: any, wallet0: SignerWithAddress): Promise<any> {

  const a51 = await deployContract(deployer, A51Artifact, [
    [wallet0.address],
    [parseUnits("5000", "18")],
  ]);

  return a51;
}
