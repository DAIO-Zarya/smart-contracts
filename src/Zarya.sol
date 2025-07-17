// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {EnumerableSet} from "@openzeppelin-contracts-5.4.0-rc.1/utils/structs/EnumerableSet.sol";

import {Regions} from "./libraries/Regions.sol";
import {PartyOrgans} from "./libraries/PartyOrgans.sol";
import {Matricies} from "./libraries/Matricies.sol";

contract Zarya {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Regions for Regions.Region;
    using Matricies for Matricies.PairOfMatricies;

    struct MemberSuggestion {
        PartyOrgans.PartyOrgan organ;
        address member;
    }

    struct CategorySuggestion {
        PartyOrgans.PartyOrgan organ;
        uint256 x;
        uint256 y;
        uint64 category;
    }

    struct DecimalsSuggestion {
        PartyOrgans.PartyOrgan organ;
        uint256 x;
        uint256 y;
        uint8 decimals;
    }

    struct ThemeSuggestion {
        bool isCategorical;
        uint256 x;
        string theme;
    }

    struct StatementSuggestion {
        bool isCategorical;
        uint256 x;
        uint256 y;
        string statement;
    }

    struct CategoricalValueSuggestion {
        PartyOrgans.PartyOrgan organ;
        uint256 x;
        uint256 y;
        uint64 value;
        address author;
    }

    struct NumericalValueSuggestion {
        PartyOrgans.PartyOrgan organ;
        uint256 x;
        uint256 y;
        uint64 value;
        address author;
    }

    mapping(PartyOrgans.PartyOrgan => EnumerableSet.AddressSet members) internal _membersByOrgan;

    Matricies.PairOfMatricies internal _matricies;

    // suggest new member to an organ

    // suggest new category to be added for categorical matrix cell

    // suggest new decimals to be added for numerical matrix cell

    // suggest new theme to be added for a cell

    // suggest new statement to be added for a cell

    // suggest new value to be added for categorical matrix cell

    // suggest new value to be added for numerical matrix cell
}
