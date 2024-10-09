# A51 Token

## Overview
A51 Token is a blockchain-based cryptocurrency project that leverages smart contracts to provide token functionalities such as minting, burning, and more. This repository contains the implementation of the A51 token contract using Solidity and TypeScript, along with necessary scripts and tests for development and deployment.

## Key Features
- Smart Contracts: Contracts are written in Solidity with features like minting, burning, and other standard ERC20 token functionalities.
- Automation: .husky and .yarn directories contain automation scripts to streamline the development process.
- Types and Tests: The types and test directories contain TypeScript types and test cases to ensure the reliability of the smart contracts.
- Deployment Scripts: Various deployment scripts in the scripts directory automate the deployment process of the contracts.
- Security: Linting and formatting configurations help maintain code quality, ensuring security and reliability.

## Tokenomics
A51 Token has recently updated its tokenomics to reflect the growing ecosystem and future goals. Some of the key tokenomics updates include:

- Total Supply: The current total supply of A51 tokens is capped at X (needs to be confirmed via tokenomics research).
- Minting: The contract allows minting of tokens to specific wallets via the mintToWallets function.
- Chain Integration: The token has multi-chain capabilities with functionalities like getChainId to handle various network-specific operations.

## Repository Structure
```
├── .github/               # GitHub workflows and CI/CD configurations
├── .husky/                # Husky hooks for Git automation
├── .yarn/                 # Yarn-related files for package management
├── contracts/             # Solidity smart contracts implementing the A51 Token
├── scripts/               # Deployment and migration scripts for the contracts
├── tasks/                 # Tasks for automating development actions
├── test/                  # Test cases written in TypeScript to ensure contract functionality
├── types/                 # TypeScript types used across the codebase
├── .env.example           # Example environment variables configuration
├── .editorconfig          # Editor configuration to maintain code formatting consistency
├── .solhint.json          # Solidity linting configuration
└── README.md              # Project documentation (you are here)
```

## Getting Started
Prerequisites
To get started with A51 Token development, ensure you have the following installed:

- Node.js: v14.x or higher
- Yarn or npm: For managing dependencies
- Hardhat: For smart contract development and testing

## Installation
Clone the repository:
```
git clone https://github.com/a51finance/A51-token.git
```
## Install dependencies using Yarn:
```
yarn install
```
## Create an environment configuration:
```
cp .env.example .env
```
Update the .env file with necessary values.

## Compilation
Compile the Solidity contracts using Hardhat:
```
yarn hardhat compile
```
## Running Tests
Run the test suite to ensure everything is working correctly:
```
yarn hardhat test
```
## Deployment
You can deploy the A51 token contract to your preferred network using the provided deployment scripts. Before deployment, update your network configuration in hardhat.config.js and make sure the .env file contains the necessary private key and network URL.

To deploy the contract:
```
yarn hardhat run scripts/deploy.js --network <network_name>
```
## Smart Contracts
Key Functions
mintToWallets: Mints new tokens to specified wallets. This function is critical for managing token distribution across multiple chains or wallets.
```
function mintToWallets(address[] memory wallets, uint256 amount) public onlyOwner {
    for (uint256 i = 0; i < wallets.length; i++) {
        _mint(wallets[i], amount);
    }
}
```
getChainId: Retrieves the chain ID to ensure multi-chain compatibility.
```
function getChainId() public view returns (uint256) {
    uint256 chainId;
    assembly {
        chainId := chainid()
    }
    return chainId;
}
```
Burn Function: The contract allows for token burning to reduce the total supply.
```
function burn(uint256 amount) public {
    _burn(msg.sender, amount);
}
```
## Contributing
Feel free to submit issues, pull requests, and feature requests! Contributions are welcome, and we encourage the community to help improve the A51 Token.

