// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";
import {ISignatureTransfer} from "lib/allo/lib/permit2/src/interfaces/ISignatureTransfer.sol";
import {DonationVotingMerkleDistributionDirectTransferStrategy} from "lib/allo/contracts/strategies/donation-voting-merkle-distribution-direct-transfer/DonationVotingMerkleDistributionDirectTransferStrategy.sol";
import {Permit2} from "lib/allo/test/utils/Permit2Mock.sol";

contract PledgePostTest is Test {
    PledgePost pledgepost;
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury =
        payable(0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f);

    address allo;
    address registry;
    ISignatureTransfer public permit2;
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
        address[] memory addresses = new address[](0);
        permit2 = ISignatureTransfer(address(new Permit2()));
        pledgepost.createRound(
            "test Round",
            permit2,
            "0x",
            1000000000000000000,
            addresses
        );
    }
}
