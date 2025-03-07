// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// import {Script, console} from "lib/forge-std/src/Script.sol";
// //import {Script, console} from "forge-std/Script.sol";
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
// import {FundMe} from "../src/FundMe.sol";

// contract FundFundMe is Script {
//     uint256 constant SEND_VALUE = 0.01 ether;
//     function fundFundMe(address mostRecentlyDeployedContract) public {
//         vm.startBroadcast();
//         FundMe(payable(mostRecentlyDeployedContract)).fund{value: SEND_VALUE}();
//         console.log("Funded FundMe contact with %s", SEND_VALUE);
//     }
//     function run() external {
//         address mostRecentlyDeployedContract = DevOpsTools
//             .get_most_recent_deployment("FundMe", block.chainid);

//         fundFundMe(mostRecentlyDeployedContract);
//     }
// }

// contract WithdrawFundMe is Script {
//     uint256 constant SEND_VALUE = 0.01 ether;
//     function withdrawFundMe(address mostRecentlyDeployedContract) public {
//         vm.startBroadcast();
//         FundMe(payable(mostRecentlyDeployedContract)).withdraw();
//         console.log("Withdrawn FundMe contact with %s", SEND_VALUE);
//         vm.stopBroadcast();
//     }
//     function run() external {
//         address mostRecentlyDeployedContract = DevOpsTools
//             .get_most_recent_deployment("FundMe", block.chainid);

//         withdrawFundMe(mostRecentlyDeployedContract);
//     }
// }

import {Script, console} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployedContract) public {
        vm.stopPrank(); // Add this line to stop any active pranks
        vm.startBroadcast(); // Start broadcast first       
        FundMe(payable(mostRecentlyDeployedContract)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe contact with %s", SEND_VALUE);
        vm.stopBroadcast(); // Stop broadcast after transaction
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        
        fundFundMe(mostRecentlyDeployedContract);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployedContract) public {
        vm.stopPrank(); // Add this line to stop any active pranks
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedContract)).withdraw();
        console.log("Withdrawn from FundMe contract");
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools
            .get_most_recent_deployment("FundMe", block.chainid);
        
        withdrawFundMe(mostRecentlyDeployedContract);
    }
}
