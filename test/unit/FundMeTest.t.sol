// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;
    uint256 constant REQ_USD = 5 * 10 ** 18;
    uint256 constant RECENT_VERSION = 4;
    function setUp() external {
        //Setup is run everytime we run any test
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUSD() public view {
        assertEq(fundMe.MINIMUM_USD(), REQ_USD);
    }

    uint256 public version;

    function testPriceFeedVersion() public {
        version = fundMe.getVersion();
        assertEq(version, RECENT_VERSION);
    }

    function testFundFailesWithoutEnoughEth() public {
        vm.expectRevert(); //The next line should revert
        fundMe.fund(); //send 0 value as you are calling fund function directly
    }

    function testUpdatedFundedData() public {
        vm.prank(USER); //The next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFundersToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address AddedFunder = fundMe.getFunder(0);
        assertEq(AddedFunder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert(); //REVERT IS EXPECTED BECAUSE USER IS NOT OWNER
        vm.prank(USER); //this is not next line for Revert, next one
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        //ARRANGE
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // this gives total balance of deployer's account
        uint256 startingFundMeBalance = address(fundMe).balance;
        //address(fundMe) refers to the Ethereum address of the deployed FundMe contract.
        //This is the contract’s address on the blockchain, where it holds any funds sent to it.
        //ACT
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //ASSERT
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithMultipleFunders() public funded {
        //ARRANGE
        uint160 totalNumberOfFunders = 10; //uint160 - To generate address from numbers
        uint160 startingFunderIndex = 1; //there's some sanity checks for 0 address so use 1
        for (uint160 i = startingFunderIndex; i <= totalNumberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE); //vm.prank(create new address) + vm.deal combined(give address some amount)
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //ACT
        uint256 gasStart = gasleft();
        console.log(gasStart);
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 gasEnd = gasleft();
        console.log(gasEnd);
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        //ASSERT
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithMultipleFundersCheaper() public funded {
        //ARRANGE
        uint160 totalNumberOfFunders = 10; //uint160 - To generate address from numbers
        uint160 startingFunderIndex = 1; //there's some sanity checks for 0 address so use 1
        for (uint160 i = startingFunderIndex; i <= totalNumberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE); //vm.prank(create new address) + vm.deal combined(give address some amount)
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //ACT
        uint256 gasStart = gasleft();
        console.log(gasStart);
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        uint256 gasEnd = gasleft();
        console.log(gasEnd);
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        //ASSERT
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }
}
