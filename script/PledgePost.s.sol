// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {PledgePost} from "../contracts/PledgePost.sol";

contract PledgePostScript is Script {
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury;

    function runc() public {
        vm.broadcast();
        new PledgePost(owner, treasury, 0, 0);
        vm.stopBroadcast();
    }
}
