// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Caution: dependencies are following remmaping.txt
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

// import Allo V2
import {Allo} from "../lib/allo/contracts/core/Allo.sol";
import {Registry} from "../lib/allo/contracts/core/Registry.sol";
import {Anchor} from "../lib/allo/contracts/core/Anchor.sol";
import {QVSimpleStrategy} from "../lib/allo/contracts/strategies/qv-simple/QVSimpleStrategy.sol";

contract Contract is Initializable {
    Allo allo;

    /// @dev see { openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol }
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        // Allo V2
        allo = new Allo();
    }
}
