// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {EnumerableSet} from "@openzeppelin-contracts-5.4.0-rc.1/utils/structs/EnumerableSet.sol";

import {Regions} from "./libraries/Regions.sol";
import {PartyOrgans} from "./libraries/PartyOrgans.sol";
import {Matricies} from "./libraries/Matricies.sol";
import {Votings} from "./libraries/Votings.sol";

contract Zarya {
    using Regions for Regions.Region;
    using EnumerableSet for EnumerableSet.AddressSet;
    using Votings for Votings.Voting;

    uint256 public nextVotingId;

    mapping(uint256 => Votings.Voting) internal _votings;
    PartyOrgans.MembersRegistry internal _partyMembersRegistry;
    Matricies.PairOfMatricies internal _matricies;

    modifier onlyActiveMember(PartyOrgans.PartyOrgan organ) {
        if (!_partyMembersRegistry.membersByOrgan[organ].contains(msg.sender)) {
            revert PartyOrgans.NotActiveMember(organ, msg.sender);
        }
        _;
    }

    modifier votingExists(uint256 votingId) {
        if (votingId >= nextVotingId) {
            revert Votings.VotingNotFound(votingId);
        }
        _;
    }

    function createMembershipVoting(PartyOrgans.PartyOrgan organ, address member, uint256 duration)
        external
        onlyActiveMember(organ)
        returns (uint256 votingId)
    {
        votingId = ++nextVotingId;
        _votings[votingId].createMembershipVoting(votingId, msg.sender, duration, organ, member);
    }

    function createCategoryVoting(PartyOrgans.PartyOrgan organ, uint256 x, uint256 y, uint64 category, uint256 duration)
        external
        onlyActiveMember(organ)
        returns (uint256 votingId)
    {
        votingId = ++nextVotingId;
        _votings[votingId].createCategoryVoting(votingId, msg.sender, duration, organ, x, y, category);
    }

    function createDecimalsVoting(PartyOrgans.PartyOrgan organ, uint256 x, uint256 y, uint8 decimals, uint256 duration)
        external
        onlyActiveMember(organ)
        returns (uint256 votingId)
    {
        votingId = ++nextVotingId;
        _votings[votingId].createDecimalsVoting(votingId, msg.sender, duration, organ, x, y, decimals);
    }

    function createThemeVoting(bool isCategorical, uint256 x, string memory theme, uint256 duration)
        external
        returns (uint256 votingId)
    {
        votingId = ++nextVotingId;
        _votings[votingId].createThemeVoting(votingId, msg.sender, duration, isCategorical, x, theme);
    }

    function createStatementVoting(bool isCategorical, uint256 x, uint256 y, string memory statement, uint256 duration)
        external
        returns (uint256 votingId)
    {
        votingId = ++nextVotingId;
        _votings[votingId].createStatementVoting(votingId, msg.sender, duration, isCategorical, x, y, statement);
    }

    function createCategoricalValueVoting(
        PartyOrgans.PartyOrgan organ,
        uint256 x,
        uint256 y,
        uint64 value,
        address valueAuthor,
        uint256 duration
    ) external onlyActiveMember(organ) returns (uint256 votingId) {
        votingId = ++nextVotingId;
        _votings[votingId].createCategoricalValueVoting(votingId, msg.sender, duration, organ, x, y, value, valueAuthor);
    }

    function createNumericalValueVoting(
        PartyOrgans.PartyOrgan organ,
        uint256 x,
        uint256 y,
        uint64 value,
        address valueAuthor,
        uint256 duration
    ) external onlyActiveMember(organ) returns (uint256 votingId) {
        votingId = ++nextVotingId;
        _votings[votingId].createNumericalValueVoting(votingId, msg.sender, duration, organ, x, y, value, valueAuthor);
    }

    // Voting participation functions
    function castVote(uint256 votingId, bool support, PartyOrgans.PartyOrgan organ)
        external
        votingExists(votingId)
        onlyActiveMember(organ)
    {
        _votings[votingId].castVote(support, msg.sender);
    }

    function executeVoting(uint256 votingId, uint256 minimumQuorum, uint256 minimumApprovalPercentage)
        external
        votingExists(votingId)
        returns (bool success)
    {
        return _votings[votingId].executeVoting(
            minimumQuorum, minimumApprovalPercentage, _matricies, _partyMembersRegistry
        );
    }

    // View functions
    function getVotingResults(uint256 votingId)
        external
        view
        votingExists(votingId)
        returns (Votings.VoteResults memory)
    {
        return _votings[votingId].getVoteResults();
    }

    function hasVoted(uint256 votingId, address member) external view votingExists(votingId) returns (bool) {
        return _votings[votingId].hasPartyMemberVoted(member);
    }

    function isVotingActive(uint256 votingId) external view votingExists(votingId) returns (bool) {
        return _votings[votingId].isActive();
    }

    function isVotingFinalized(uint256 votingId) external view votingExists(votingId) returns (bool) {
        return _votings[votingId].isFinalized();
    }
}
