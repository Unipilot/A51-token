// We require the Hardhat Runtime Environment explicitly here. This is optional but useful for running the
// script in a standalone fashion through `node <script>`. When running the script with `hardhat run <script>`,
// you'll find the Hardhat Runtime Environment's members available in the global scope.
import hre from "hardhat";
import { ethers } from "hardhat";
import { BigNumberish } from "ethers";
import { parseUnits } from "ethers/lib/utils";

import { Contract, ContractFactory } from "@ethersproject/contracts";

async function main(): Promise<void> {
  const [wallet] = await ethers.getSigners();
  const A51: ContractFactory = await ethers.getContractFactory("A51");


  let vestingAddresses: string[] = [
    "0x8eeFB7A090D1D8Caea8860eb8A6B8d1A2e28Da85",
    "0x7978e0DD77fAda400063D1b78c9fa8CE84bAf7B1",
    "0xe7Ef8E1402055EB4E89a57d1109EfF3bAA334F5F",
    "0x91097AcB2E86245d63a602110ACCE4A289b58324",
    "0x522A02DE738e7BFca3866086e8429851f4bFCB83",
  ];

  let vestingAmounts: BigNumberish[] = [
    parseUnits("5000", "18"),
    parseUnits("5000", "18"),
    parseUnits("5000", "18"),
    parseUnits("5000", "18"),
    parseUnits("5000", "18"),
  ];

  const a51: Contract = await A51.deploy(vestingAddresses, vestingAmounts);

  await a51.deployed();

  console.log("A51 Finance token deployed to ->", a51.address);

  delay(60000);

  await hre.run("verify:verify", {
    address: a51.address,
    constructorArguments: [
      vestingAddresses,
      vestingAmounts
    ],
  });
}

function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
