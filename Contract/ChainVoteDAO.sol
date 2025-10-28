// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChainVoteDAO
 * @dev A simple decentralized autonomous organization (DAO) for community voting.
 */
contract ChainVoteDAO {

    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCount;
    address public owner;

    event ProposalCreated(uint256 indexed id, string description);
    event Voted(uint256 indexed id, address indexed voter);
    event ProposalExecuted(uint256 indexed id, string description);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Create a new proposal.
     * @param _description The description of the proposal.
     */
    function createProposal(string memory _description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, _description, 0, false);
        emit ProposalCreated(proposalCount, _description);
    }

    /**
     * @dev Vote for a proposal by ID.
     * @param _proposalId The ID of the proposal to vote for.
     */
    function vote(uint256 _proposalId) public {
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal ID");
        require(!hasVoted[_proposalId][msg.sender], "Already voted on this proposal");

        hasVoted[_proposalId][msg.sender] = true;
        proposals[_proposalId].voteCount++;

        emit Voted(_proposalId, msg.sender);
    }

    /**
     * @dev Execute a proposal (only the owner can execute).
     * @param _proposalId The ID of the proposal to execute.
     */
    function executeProposal(uint256 _proposalId) public onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > 0, "Proposal must have votes to execute");

        proposal.executed = true;
        emit ProposalExecuted(_proposalId, proposal.description);
    }
}

