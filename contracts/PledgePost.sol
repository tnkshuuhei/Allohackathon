// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Caution: dependencies are following remmaping.txt

// import Allo V2
import {Allo} from "../lib/allo/contracts/core/Allo.sol";
import {Registry} from "../lib/allo/contracts/core/Registry.sol";
import {Anchor} from "../lib/allo/contracts/core/Anchor.sol";
import {QVSimpleStrategy} from "../lib/allo/contracts/strategies/qv-simple/QVSimpleStrategy.sol";
import {Metadata} from "../lib/allo/contracts/core/libraries/Metadata.sol";

contract PledgePost {
    Allo allo;
    Registry registry;
    Anchor anchor;
    QVSimpleStrategy qvSimpleStrategy;

    uint256 nonce;

    constructor(
        address _owner,
        address payable _treasury,
        uint256 _percentFee,
        uint256 _baseFee
    ) {
        nonce = 0;

        // deploy Allo V2 contracts
        registry = new Registry();
        qvSimpleStrategy = new QVSimpleStrategy(
            address(allo),
            "PledgePost QVSimpleStrategy"
        );
        registry.initialize(_owner);
        registry.createProfile(
            nonce,
            "PledgePost Owner Profile",
            Metadata({protocol: 1, pointer: "PledgePost"}),
            _owner,
            new address[](0)
        );
        allo.initialize(
            _owner,
            address(registry),
            _treasury,
            _percentFee,
            _baseFee
        );
        nonce++;
    }

    function createRound() external {}
}
