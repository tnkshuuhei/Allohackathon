// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";
import {IRegistry} from "../../lib/allo/contracts/core/interfaces/IRegistry.sol";
import {Metadata} from "../../lib/allo/contracts/core/libraries/Metadata.sol";
import {IAllo} from "../../lib/allo/contracts/core/interfaces/IAllo.sol";
import {QVBaseStrategy} from "../../lib/allo/contracts/strategies/qv-base/QVBaseStrategy.sol";
import {QVSimpleStrategy} from "../../lib/allo/contracts/strategies/qv-simple/QVSimpleStrategy.sol";

// TODO: create profile via registry directly, instead of using PledgePost

contract PledgePostTest is Test {
    PledgePost pledgepost;
    address owner = makeAddr("Owner");
    address payable treasury = payable(makeAddr("Treasury"));
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
        vm.startPrank(msg.sender);
        pledgepost = new PledgePost(owner, treasury, 0, 0);
        emit log_named_address("pledgepost", address(pledgepost));
        emit log_named_address("address(this)", address(this));
        emit log_named_address("msg.sender", msg.sender);
        vm.stopPrank();
    }

    function testPostArticle() public {
        vm.prank(msg.sender);
        pledgepost.postArticle("Test Article 1", new address[](0));
        vm.prank(makeAddr("Author 1"));
        pledgepost.postArticle("Test Article 2", new address[](0));
    }

    function testCreateRound() public {
        vm.startPrank(msg.sender);
        address[] memory addresses = new address[](1);
        addresses[0] = owner;
        registrationStartTime = uint64(block.timestamp);
        registrationEndTime = uint64(block.timestamp + 300);
        allocationStartTime = uint64(block.timestamp + 301);
        allocationEndTime = uint64(block.timestamp + 600);

        uint256 poolId = pledgepost.createRound{value: 1e18}(
            "test Round",
            1e18,
            addresses,
            registrationStartTime,
            registrationEndTime,
            allocationStartTime,
            allocationEndTime
        );
        emit log_named_uint("poolId", poolId);
        assertEq(poolId, 1);
    }

    function testApplyForRound() public {
        vm.startPrank(msg.sender);
        // createRound()
        address[] memory addresses = new address[](0);
        registrationStartTime = uint64(block.timestamp);
        registrationEndTime = uint64(block.timestamp + 300);
        allocationStartTime = uint64(block.timestamp);
        allocationEndTime = uint64(block.timestamp + 600);

        uint256 poolId = pledgepost.createRound{value: 1e18}(
            "test Round",
            1e18,
            addresses,
            registrationStartTime,
            registrationEndTime,
            allocationStartTime,
            allocationEndTime
        );
        // apply msg.sender as author
        PledgePost.Article memory article1 = pledgepost.postArticle(
            "Test Article 1",
            new address[](0)
        );
        bytes32 profileId = article1.profileId;
        IRegistry.Profile memory profile = pledgepost.getProfileById(profileId);
        Metadata memory metadata = profile.metadata;
        bytes memory data = abi.encode(msg.sender, profile.anchor, metadata);
        address recipientId = IAllo(pledgepost.getAlloAddress())
            .registerRecipient(poolId, data);
        emit log_named_address("recipientId", recipientId);
        vm.stopPrank();

        // apply Author 1 as author
        address author1 = makeAddr("Author 1");
        vm.startPrank(author1);
        PledgePost.Article memory article2 = pledgepost.postArticle(
            "Test Article 2",
            new address[](0)
        );
        bytes32 profileId2 = article2.profileId;
        IRegistry.Profile memory profile2 = pledgepost.getProfileById(
            profileId2
        );
        Metadata memory metadata2 = profile2.metadata;
        bytes memory data2 = abi.encode(author1, profile2.anchor, metadata2);
        address recipientId2 = IAllo(pledgepost.getAlloAddress())
            .registerRecipient(poolId, data2);
        emit log_named_address("recipientId2", recipientId2);
        vm.stopPrank();

        // DonateToArticle()
        vm.startPrank(msg.sender);

        pledgepost.donateToArticle{value: 1e17}(
            payable(author1),
            article2.id,
            poolId
        );
        vm.stopPrank();
    }
}
