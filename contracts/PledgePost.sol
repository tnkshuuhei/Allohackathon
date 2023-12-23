// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import {Ownable} from "lib/allo/lib/openzeppelin-contracts/contracts/access/Ownable.sol";
// import Allo V2
import {Allo} from "lib/allo/contracts/core/Allo.sol";
import {Registry} from "lib/allo/contracts/core/Registry.sol";
// import {Anchor} from "../lib/allo/contracts/core/Anchor.sol";
// import {QVSimpleStrategy} from "../lib/allo/contracts/strategies/qv-simple/QVSimpleStrategy.sol";
import {Metadata} from "../lib/allo/contracts/core/libraries/Metadata.sol";
import {ISignatureTransfer} from "lib/allo/lib/permit2/src/interfaces/ISignatureTransfer.sol";
import {DonationVotingMerkleDistributionDirectTransferStrategy} from "lib/allo/contracts/strategies/donation-voting-merkle-distribution-direct-transfer/DonationVotingMerkleDistributionDirectTransferStrategy.sol";

contract PledgePost {
    Allo allo;
    Registry registry;
    DonationVotingMerkleDistributionDirectTransferStrategy strategy;
    // Anchor anchor;
    address public constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    uint256 nonce = 0;
    uint256 articleCount = 0;

    bytes32 public ownerProfileId;
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
        uint256 indexed poolId,
        string name,
        address token,
        uint256 amount,
        address strategy
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
        ownerProfileId = registry.createProfile(
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

    ///  _data The data to be decoded to initialize the strategy
    ///  InitializeData(bool _useRegistryAnchor, bool _metadataRequired, uint64 _registrationStartTime,
    ///               uint64 _registrationEndTime, uint64 _allocationStartTime, uint64 _allocationEndTime,
    ///               address[] memory _allowedTokens)
    function createRound(
        string calldata _name,
        // string calldata _description,
        address[] memory _managers,
        uint256 _amount,
        ISignatureTransfer _permit2,
        bytes memory _data
    ) external returns (uint256) {
        // initialize strategy
        strategy = new DonationVotingMerkleDistributionDirectTransferStrategy(
            address(allo),
            _name,
            _permit2
        );
        Metadata memory _metadata = Metadata({
            protocol: 1,
            pointer: "PledgePost QF Strategy"
        });
        uint256 poolId = allo.createPoolWithCustomStrategy(
            ownerProfileId,
            address(strategy),
            _data,
            NATIVE,
            _amount,
            _metadata,
            _managers
        );
        emit RoundCreated(poolId, _name, NATIVE, _amount, address(strategy));
        return poolId;
    }

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
