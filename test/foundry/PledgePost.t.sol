// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";

contract PledgePostTest is Test {
    PledgePost pledgePost;
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury;

    function setUp() public {
        pledgePost = new PledgePost(owner, treasury, 0, 0);
    }
}
