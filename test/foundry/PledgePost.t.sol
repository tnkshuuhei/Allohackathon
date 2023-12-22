// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";

contract PledgePostTest is Test {
    PledgePost pledgepost;
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury =
        payable(0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f);

    function setUp() public {
        pledgepost = new PledgePost(owner, treasury, 0, 0);
    }

    function testgetAlloAddress() public {
        address allo = pledgepost.getAlloAddress();
        emit log_named_address("allo", allo);
        assertNotEq(allo, address(0));
    } 
}
