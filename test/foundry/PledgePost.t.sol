// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";

contract PledgePostTest is Test {
    PledgePost pledgepost;
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury =
        payable(0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f);
    uint64 public registrationStartTime;
    uint64 public registrationEndTime;
    uint64 public allocationStartTime;
    uint64 public allocationEndTime;

    address allo;
    address registry;

    //0x000000000022d473030f116ddee9f6b43ac78ba3 uniswap
    // https://docs.uniswap.org/contracts/v3/reference/deployments

    event ArticlePosted(
        address indexed author,
        string content,
        uint256 articleId,
        bytes32 profileId
    );

    function setUp() public {
        pledgepost = new PledgePost(msg.sender, treasury, 0, 0);
    }

    function testgetAlloAddress() public {
        allo = pledgepost.getAlloAddress();
        emit log_named_address("allo", allo);
        assertNotEq(allo, address(0));
    }

    function testgetRegistryAddress() public {
        registry = pledgepost.getRegistryAddress();
        emit log_named_address("registry", registry);
        assertNotEq(registry, address(0));
    }

    function testPostArticle() public {
        string memory content = "Test Article";
        address[] memory addresses = new address[](0);
        pledgepost.postArticle(content, addresses);
    }

    function testCreateRound() public {
        address[] memory addresses = new address[](1);
        addresses[0] = owner;
        registrationStartTime = uint64(block.timestamp + 10);
        registrationEndTime = uint64(block.timestamp + 300);
        allocationStartTime = uint64(block.timestamp + 301);
        allocationEndTime = uint64(block.timestamp + 600);

        // permit2 = ISignatureTransfer(address(new Permit2()));
        uint256 poolId = pledgepost.createRound{value: 1e18}(
            "test Round",
            // permit2,
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
}
