// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {

    struct Proposal {
        string description; // Description of the proposal
        uint256 approve; // Number of approve votes
        uint256 reject; // Number of reject votes
        uint256 pass; // Number of pass votes
        uint256 total_vote_to_end; // When the total votes in the proposal reaches this limit, proposal ends
        bool current_state; // This shows the current state of the proposal, meaning whether if passes of fails
        bool is_active; // This shows if others can vote to our contract
    }

    mapping(uint256 => Proposal) proposal_history; // Recordings of previous proposals
    Proposal proposal;
    uint256 proposalid;
    bool activeproposal = false;
    uint256 votes_count = 0;


    constructor (){
        proposalid = 0;
    }


    modifier canpropose() {
        require (activeproposal == false , "A proposal in activity");
        _ ;
    }

    modifier canvote(){
        require(votes_count !=0,"vote reached");
        _ ;
    }


//track function to actively keep track of proposal state
    function track() private {
        votes_count --;
        if(votes_count == 0){
            activeproposal = false;
        }
        if(proposal.approve > proposal.reject){
            proposal.current_state =  true;
        }
        else {
            proposal.current_state = false;
        }
    }


    function _createproposal(string memory descriptions , uint256 total_vote) external canpropose{
        proposal_history[proposalid] = proposal;
        proposalid ++;
        proposal.description = descriptions;
        proposal.approve = 0;
        proposal.reject = 0 ;
        proposal.pass = 0;
        proposal.total_vote_to_end = total_vote;
        votes_count = total_vote;
        proposal.current_state = false;
        proposal.is_active = true;
        activeproposal = true;
    }

    function accept() external canvote{
        proposal.approve ++;
        track();
    }
    function reject() external canvote{
        proposal.reject ++;
        track();
    }
    function pass() external canvote{
        proposal.pass ++;
        track();

    }
    function result() view external returns (string memory){
        if (proposal.current_state){
            return "proposal is accepted";
        }
        else{
            return "proposal is rejected";
        }
    }
    function status() view external returns (string memory){
        if(votes_count !=0){
            return "voting open";        }
        else {
            return "voting closed";
        }
    }

}
