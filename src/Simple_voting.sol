//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

interface IVoting {
    struct Voter {
        bool registered;
        bool voted;
        uint256 vote;
        uint256 weight;
        //address delegate; why do we need this for
    }

    struct Proposal {
        string name;
        uint256 voteCount;
    }

    

    function registerVoter(address voter) external;

    function createProposalForNFT(
        string memory proposalCategory
    ) external;

    // function createNewRentalNFT() external;
    function vote(uint256 proposalNFTID) external;

    function winningProposal() external view returns (uint256 winningProposal_);
}

contract Voting is IVoting, Ownable {
    address public admin;
    uint256 public winningProposalId;

    // mapping(uint256 => Proposal) public TransactionsPool;
    // mapping(uint256 => address[]) public OwnersControlAccess;
    // mapping(uint256 => NFTCreate) public AvailableNFTs;

    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    modifier onlyAdmin() {
        require(msg.sender == owner(), "Only admin can call this function");
        _;
    }

    constructor() Ownable(msg.sender) {}

    function registerVoter(address voter) external onlyAdmin {
        require(!voters[voter].registered, "Voter already registered");
        voters[voter].registered = true;
    }

    function createProposalForNFT(
        string memory name
    ) external onlyAdmin {
        proposals.push(
            Proposal({
                name: name,
                voteCount: 0
            })
        );
    }

    function vote(uint256 proposalNFTID) external override {
        require(
            voters[msg.sender].registered,
            "You are not a registered voter"
        );
        require(!voters[msg.sender].voted, "You have already voted");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = proposalNFTID;
        proposals[proposalNFTID].voteCount += voters[msg.sender].weight;
    }

    function winningProposal()
        external
        view
        override
        returns (uint256 winningProposal_)
    {
        uint256 winningVoteCount = 0;
         
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
        return winningProposal_;
    }
}
