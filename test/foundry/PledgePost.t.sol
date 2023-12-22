// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../../contracts/PledgePost.sol";

contract PledgePostTest is Test {
    PledgePost pledgepost;
    address owner = 0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f;
    address payable treasury =
        payable(0x9B789cc315F1eedFbCBE759DEbb5a3D5D41B788f);

    address allo;
    address registry;
    event ArticlePosted(
        address indexed author,
        string content,
        uint256 articleId,
        bytes32 profileId
    );

    function setUp() public {
        pledgepost = new PledgePost(owner, treasury, 0, 0);
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

    function testgetStrategyAddress() public {
        address strategy = pledgepost.getQVSimpleStrategyAddress();
        emit log_named_address("strategy", strategy);
        assertNotEq(strategy, address(0));
    }

    function testPostArticle() public {
        string memory content = "Test Article";
        address[] memory addresses = new address[](0);
        pledgepost.postArticle(content, addresses);
    }
}
