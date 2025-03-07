// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Why is this a library and not abstract?
// Why not an interface?
library PriceConverter {
    // We could make this public, but then we'd have to deploy it
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        (, int256 answer, , , ) = priceFeed.latestRoundData(); //8 decimals
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    // 1000000000
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000; // Example 5 apples (EthAmount) priced at 3 dollars (ethPrice) each
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
        // console.log("ETH Price from PriceFeed:", ethPrice);
        // console.log("ETH Amount (Ether):", ethAmount);
        // console.log("Converted USD Value:", ethAmountInUsd);
    }
}

//This contract Converts an ETH amount to its USD equivalent ( in 18 decimals).
