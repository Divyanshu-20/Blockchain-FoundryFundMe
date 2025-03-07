Blockchain FundMe

A decentralized crowdfunding smart contract built with Solidity and Foundry.

Overview
This project implements a funding contract on the Ethereum blockchain that allows users to:
Fund the contract with ETH (minimum of 5 USD equivalent)
Convert between ETH and USD using Chainlink Price Feeds
Withdraw funds (owner only)

Features

ETH to USD Conversion: Uses Chainlink Price Feeds to ensure minimum funding amounts
Withdrawal Optimization: Includes both standard and gas-optimized withdrawal functions
Access Control: Only the contract owner can withdraw funds
Fallback Functions: Automatic handling of direct ETH transfers

Getting Started

Prerequisites
Foundry
Git

Installation
Clone the repository
Copy: git clone https://github.com/Divyanshu-20/Blockchain_FundMe.git
cd Blockchain_FundMe

Install dependencies

forge install
Build the project
forge build

Usage:

Deploying

Deploy to a local Anvil chain:
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --private-key <your-private-key> --broadcast

Interacting with the Contract:
Fund the contract
cast send <CONTRACT_ADDRESS> "fund()" --value 0.1ether --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>
Withdraw (owner only):
cast send <CONTRACT_ADDRESS> "withdraw()" --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>

Testing:
Run the test suite:
forge test
Run with verbosity for more details:
forge test -vv

License:
This project is licensed under the MIT License.