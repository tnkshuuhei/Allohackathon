// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {PledgePost} from "../contracts/PledgePost.sol";

contract PledgePostScript is Script {
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury =
        payable(0x06aa005386F53Ba7b980c61e0D067CaBc7602a62);

    function run() public {
        vm.startBroadcast();
        new PledgePost(owner, treasury, 0, 0);
        vm.stopBroadcast();
    }
}
