// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


// import {FundMe} from "../../src/FundMe.sol";
// // import {Test, console} from "forge-std/Test.sol";
// import {Test} from "lib/forge-std/src/Test.sol";
// import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
// import {FundFundMe, WithdrawFundMe } from "../../script/Interactions.s.sol";

// contract InteractionsTest is Test {
//     FundMe fundMe;
//     address USER = makeAddr("user");
//     uint256 constant SEND_VALUE = 10 ether;
//     uint256 constant STARTING_BALANCE = 10 ether;
//     uint256 constant GAS_PRICE = 1;

//     function setUp() external {
//         //Setup is run everytime we run any test
//         DeployFundMe deployFundMe = new DeployFundMe();
//         fundMe = deployFundMe.run();
//         //vm.deal(USER, STARTING_BALANCE);
//     }

//     function testUserCanFundInteractions() public {
        
//         FundFundMe fundFundMe = new FundFundMe(); // FundFundMe is contract, fundfundMe is instance, fundFundMe is function in contract
//         vm.prank(USER);
//         vm.deal(USER, 1e18);
//         fundFundMe.fundFundMe(address(fundMe));

//         WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
//         withdrawFundMe.withdrawFundMe(address(fundMe));

//         assert(address(fundMe).balance == 0);
//     }
// }



import {FundMe} from "../../src/FundMe.sol";
import {Test} from "lib/forge-std/src/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // Set up the test with the correct sender
        vm.prank(USER);
        
        FundFundMe fundfundMe = new FundFundMe(); //FundFundMe -> Contract, fundfundMe -> Instance, fundFundMe -> Function
        fundfundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawfundMe = new WithdrawFundMe();
        withdrawfundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}