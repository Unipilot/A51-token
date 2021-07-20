// We require the Hardhat Runtime Environment explicitly here. This is optional but useful for running the
// script in a standalone fashion through `node <script>`. When running the script with `hardhat run <script>`,
// you'll find the Hardhat Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { formatUnits, parseUnits } from "ethers/lib/utils";
import { Contract, ContractFactory } from "@ethersproject/contracts";
import PilotArtifact from "../artifacts/contracts/Pilot.sol/Pilot.json";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { BigNumberish } from "ethers";
let wallet: SignerWithAddress;

let pilotContractInstance: Contract;

async function updateStateVariables(): Promise<void> {
  const [_wallet] = await ethers.getSigners();
  wallet = _wallet;
}

async function initializePilotFromAddress(pilotAddress: string): Promise<void> {
  const pilotContract = new ContractFactory(PilotArtifact.abi, PilotArtifact.bytecode, wallet);
  pilotContractInstance = pilotContract.attach(pilotAddress);
}

async function deployPilot(
  timelockAddr: string,
  vestingAddresses: string[],
  vestingAmounts: BigNumberish[],
): Promise<void> {
  const [wallet] = await ethers.getSigners();
  const Pilot: ContractFactory = await ethers.getContractFactory("Pilot");
  const pilot: Contract = await Pilot.deploy(timelockAddr, vestingAddresses, vestingAmounts);
  await pilot.deployed();

  console.log("Wallet ->", wallet.address);
  console.log("Pilot ->", pilot.address);
}

async function main(): Promise<void> {
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
  await deployPilot("0x43D964B802c2Ce187653F6A01D6678E6cA0DC9Bb", vestingAddresses, vestingAmounts);
}

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
