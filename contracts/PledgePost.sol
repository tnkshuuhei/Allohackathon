// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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

    struct Article {
        uint256 id;
        address payable author;
        string content; // CID
        uint256 donationsReceived;
    }
    enum ApplicationStatus {
        Pending,
        Accepted,
        Denied
    }
    event ArticlePosted(
        address indexed author,
        string content,
        uint256 articleId
    );
    event ArticleDonated(
        address indexed author,
        address indexed from,
        uint256 articleId,
        uint256 amount
    );
    event RoundCreated(
        address indexed owner,
        address ipoolAddress,
        uint256 roundId,
        bytes name,
        bytes description,
        uint256 startDate,
        uint256 endDate
    );
    event RoundApplied(
        address indexed author,
        uint256 articleId,
        uint256 roundId
    );
    event Allocated(
        uint256 indexed roundId,
        address recipient,
        uint256 articleId,
        uint256 amount
    );

    constructor(
        address _owner,
        address payable _treasury,
        uint256 _percentFee,
        uint256 _baseFee
    ) {
        nonce = 0;

        // deploy Allo V2 contracts
        registry = new Registry();
        allo = new Allo();
        qvSimpleStrategy = new QVSimpleStrategy(
            address(allo),
            "PledgePost QVSimpleStrategy"
        );
        // initialize Allo V2 contracts
        registry.initialize(_owner);
        allo.initialize(
            _owner,
            address(registry),
            payable(_treasury),
            _percentFee,
            _baseFee
        );
        // create a new profile for the owner
        bytes32 ownerProfile = registry.createProfile(
            nonce,
            "PledgePost Owner Profile",
            Metadata({protocol: 1, pointer: "PledgePost"}),
            _owner,
            new address[](0)
        );
        nonce++;
    }

    function postArticle(string calldata _content) external {}

    function updateArticle(
        uint256 _articleId,
        string calldata _content
    ) external {}

    function donateToArticle(
        address payable _author,
        uint256 _articleId
    ) external payable {}

    function applyForRound(uint256 _roundId, uint256 _articleId) external {}

    function createRound(
        string calldata _name,
        string calldata _description,
        uint256 _startDate,
        uint256 _endDate
    ) external {}

    function getAlloAddress() external view returns (address) {
        return address(allo);
    }
}
