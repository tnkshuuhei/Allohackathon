// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import Allo V2
import {Allo} from "../lib/allo/contracts/core/Allo.sol";
import {Registry} from "../lib/allo/contracts/core/Registry.sol";
// import {Anchor} from "../lib/allo/contracts/core/Anchor.sol";
import {QVSimpleStrategy} from "../lib/allo/contracts/strategies/qv-simple/QVSimpleStrategy.sol";
import {Metadata} from "../lib/allo/contracts/core/libraries/Metadata.sol";

contract PledgePost {
    Allo allo;
    Registry registry;
    QVSimpleStrategy qvSimpleStrategy;
    // Anchor anchor;

    uint256 nonce = 0;
    uint256 articleCount = 0;
    // author => articles
    // track articles by author
    mapping(address => Article[]) private authorArticles;

    // profileId => articles
    mapping(bytes32 => Article) private profileArticle;

    struct Article {
        uint256 id;
        address payable author;
        string content; // CID
        uint256 donationsReceived;
        bytes32 profileId;
        uint256 articleCount;
    }
    enum ApplicationStatus {
        Pending,
        Accepted,
        Denied
    }
    event ArticlePosted(
        address indexed author,
        string content,
        uint256 articleId,
        bytes32 profileId
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
        registry.createProfile(
            nonce,
            "PledgePost Contract Owner Profile",
            Metadata({protocol: 1, pointer: "PledgePost"}),
            _owner,
            new address[](0)
        );
        nonce++;
    }

    // ====================================
    // PleldgePost function
    // ====================================

    function postArticle(
        string memory _content,
        address[] memory _contributors
    ) external returns (Article memory) {
        require(bytes(_content).length > 0, "Content cannot be empty");
        bytes32 profileId = registry.createProfile(
            nonce,
            "PledgePost Author Profile:",
            Metadata({protocol: 1, pointer: "PledgePost"}),
            msg.sender,
            _contributors
        );
        uint articleId = authorArticles[msg.sender].length;
        Article memory newArticle = Article({
            id: articleId,
            author: payable(msg.sender),
            content: _content,
            donationsReceived: 0,
            profileId: profileId,
            articleCount: articleCount
        });

        authorArticles[msg.sender].push(newArticle);
        articleCount++;
        emit ArticlePosted(msg.sender, _content, articleId, profileId);
        return newArticle;
    }

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

    function getArticlesByAuthor(
        address _author
    ) external view returns (Article[] memory) {
        return authorArticles[_author];
    }

    function getArticleByProfileId(
        bytes32 _profileId
    ) external view returns (Article memory) {
        return profileArticle[_profileId];
    }

    // ====================================
    // Registry function
    // ====================================

    function addMembers(
        bytes32 _profileId,
        address[] calldata _members
    ) external {
        registry.addMembers(_profileId, _members);
    }

    function getAlloAddress() external view returns (address) {
        return address(allo);
    }

    function getRegistryAddress() external view returns (address) {
        return address(registry);
    }

    function getQVSimpleStrategyAddress() external view returns (address) {
        return address(qvSimpleStrategy);
    }
}
