// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";
import {IRegistry} from "lib/allo/contracts/core/interfaces/IRegistry.sol";
import {Metadata} from "lib/allo/contracts/core/libraries/Metadata.sol";
import {IAllo} from "lib/allo/contracts/core/interfaces/IAllo.sol";
import {QVBaseStrategy} from "lib/allo/contracts/strategies/qv-base/QVBaseStrategy.sol";
import {QVSimpleStrategy} from "lib/allo/contracts/strategies/qv-simple/QVSimpleStrategy.sol";

// TODO: create profile via registry directly, instead of using PledgePost

contract PledgePostTest is Test {
    PledgePost pledgepost;
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury =
        payable(0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f);
    uint64 public registrationStartTime;
    uint64 public registrationEndTime;
    uint64 public allocationStartTime;
    uint64 public allocationEndTime;

    event ArticlePosted(
        address indexed author,
        string content,
        uint256 articleId,
        bytes32 profileId
    );

    function setUp() public {
        pledgepost = new PledgePost(msg.sender, treasury, 0, 0);
        emit log_named_address("pledgepost", address(pledgepost));
        emit log_named_address("address(this)", address(this));
        emit log_named_address("msg.sender", msg.sender);
    }

    function testgetAlloAddress() public {
        address allo = pledgepost.getAlloAddress();
        emit log_named_address("allo", allo);
        assertNotEq(allo, address(0));
        assertEq(allo, pledgepost.getAlloAddress());
    }

    function testgetRegistryAddress() public {
        address registry = pledgepost.getRegistryAddress();
        emit log_named_address("registry", registry);
        assertNotEq(registry, address(0));
        assertEq(registry, pledgepost.getRegistryAddress());
    }

    function testPostArticle() public {
        address[] memory addresses = new address[](0);
        pledgepost.postArticle("Test Article 1", addresses);
        pledgepost.postArticle("Test Article 2", addresses);
    }

    function testCreateRound() public {
        address[] memory addresses = new address[](1);
        addresses[0] = owner;
        registrationStartTime = uint64(block.timestamp);
        registrationEndTime = uint64(block.timestamp + 300);
        allocationStartTime = uint64(block.timestamp + 301);
        allocationEndTime = uint64(block.timestamp + 600);

        (uint256 poolId, address strategy) = pledgepost.createRound{
            value: 1e18
        }(
            "test Round",
            1e18,
            addresses,
            registrationStartTime,
            registrationEndTime,
            allocationStartTime,
            allocationEndTime
        );
        emit log_named_uint("poolId", poolId);
        emit log_named_address("strategy", strategy);
        assertEq(poolId, 1);
        assertNotEq(strategy, address(0));
        assertEq(pledgepost.getStrategyAddress(1), strategy);
    }

    function testApplyForRound() public {
        // postArticle()
        string memory content = "Test Article";
        address[] memory contributors = new address[](0);

        PledgePost.Article memory article = pledgepost.postArticle(
            content,
            contributors
        );
        bytes32 profileId = article.profileId;
        IRegistry.Profile memory profile = pledgepost.getProfileById(profileId);
        Metadata memory metadata = profile.metadata;
        assertEq(profileId, profile.id);
        address anchor = profile.anchor;
        assertNotEq(anchor, address(0));

        // createRound()
        address[] memory addresses = new address[](0);

        registrationStartTime = uint64(block.timestamp);
        registrationEndTime = uint64(block.timestamp + 300);
        allocationStartTime = uint64(block.timestamp + 301);
        allocationEndTime = uint64(block.timestamp + 600);

        (uint256 poolId, address strategy) = pledgepost.createRound{
            value: 1e18
        }(
            "test Round",
            1e18,
            addresses,
            registrationStartTime,
            registrationEndTime,
            allocationStartTime,
            allocationEndTime
        );

        // applyForRound()
        bytes memory data = abi.encode(address(this), anchor, metadata);
        bool hasProfile = IRegistry(pledgepost.getRegistryAddress())
            .isOwnerOrMemberOfProfile(profileId, address(this));
        assertEq(hasProfile, true);
        address recipientId = IAllo(pledgepost.getAlloAddress())
            .registerRecipient(poolId, data);
        QVBaseStrategy.Recipient memory recipient = QVSimpleStrategy(
            payable(strategy)
        ).getRecipient(recipientId);
    }
}
