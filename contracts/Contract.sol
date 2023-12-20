// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

// interfaces


contract Contract is Initializable {
    // IAllo public allo;
    // IRegistry public registry;
    // IStrategy public strategy;

    /// @dev see { openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol }
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // function initialize(
    //     IAllo _allo,
    //     IRegistry _registry,
    //     IStrategy _strategy
    // ) public initializer {
    //     allo = _allo;
    //     registry = _registry;
    //     strategy = _strategy;
    // }
}
