// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {RentalNft} from "../src/Rental_Nft.sol";

contract RentalNftTest is Test {
    function setup() public {
        address[] memory owners = new address[](2);
        owners[0]=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        owners[1]=0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

        // vm.startPrank(owner);




    }
}

