// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {PledgePost} from "../contracts/PledgePost.sol";

contract PledgePostScript is Script {
    function runc() public {
        vm.broadcast();
        new PledgePost();
        vm.stopBroadcast();
    }
}
