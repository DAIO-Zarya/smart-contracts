// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {Checkpoints} from "@openzeppelin-contracts-5.4.0-rc.1/utils/structs/Checkpoints.sol";
import {EnumerableSet} from "@openzeppelin-contracts-5.4.0-rc.1/utils/structs/EnumerableSet.sol";

import {PartyOrgans} from "./PartyOrgans.sol";

library Matricies {
    using Checkpoints for Checkpoints.Trace224;
    using EnumerableSet for EnumerableSet.UintSet;

    struct CategoricalCell {
        Checkpoints.Trace224 categoricalSample;
        EnumerableSet.UintSet allowedCategories;
    }

    struct NumericalCell {
        Checkpoints.Trace224 numericalSample;
        uint8 decimals;
    }

    struct PairOfMatricies {
        mapping(bool isCategorical => mapping(uint256 x => string theme)) themes;
        mapping(bool isCategorical => mapping(uint256 y => string statement)) statements;
        mapping(uint256 x => mapping(PartyOrgans.PartyOrgan organ => mapping(uint256 y => CategoricalCell)))
            categoricalMatrix;
        mapping(uint256 x => mapping(PartyOrgans.PartyOrgan organ => mapping(uint256 y => NumericalCell)))
            numericalMatrix;
    }

    error NoStatementSet(bool isCategorical, uint256 y);
    error NoThemeSet(bool isCategorical, uint256 x);
    error CategoryAlreadyExists(uint64 category);
    error InvalidCategory(uint64 category);

    event ValueAdded(uint256 indexed x, uint256 indexed y, uint64 value, address indexed author);
    event CategoryAdded(uint256 indexed x, uint256 indexed y, uint64 category);

    function isCategoryAllowed(
        PairOfMatricies storage self,
        PartyOrgans.PartyOrgan organ,
        uint256 x,
        uint256 y,
        uint64 category
    ) internal view returns (bool) {
        return self.categoricalMatrix[x][organ][y].allowedCategories.contains(category);
    }

    function addValue(
        PairOfMatricies storage self,
        PartyOrgans.PartyOrgan organ,
        uint256 x,
        uint256 y,
        uint64 value,
        address author,
        bool isCategorical
    ) external {
        if (bytes(self.themes[isCategorical][x]).length == 0) {
            revert NoThemeSet(isCategorical, x);
        }
        if (bytes(self.statements[isCategorical][y]).length == 0) {
            revert NoStatementSet(isCategorical, y);
        }
        if (isCategorical) {
            if (!isCategoryAllowed(self, organ, x, y, value)) {
                revert InvalidCategory(value);
            }
            self.categoricalMatrix[x][organ][y].categoricalSample.push(
                uint32(block.timestamp), uint224(bytes28(abi.encodePacked(author, value)))
            );
        } else {
            self.numericalMatrix[x][organ][y].numericalSample.push(
                uint32(block.timestamp), uint224(bytes28(abi.encodePacked(author, value)))
            );
        }
        emit ValueAdded(x, y, value, author);
    }

    function addCategory(
        PairOfMatricies storage self,
        PartyOrgans.PartyOrgan organ,
        uint256 x,
        uint256 y,
        uint64 category
    ) external {
        if (!self.categoricalMatrix[x][organ][y].allowedCategories.add(category)) {
            revert CategoryAlreadyExists(category);
        }
        emit CategoryAdded(x, y, category);
    }

    function setDecimals(
        PairOfMatricies storage self,
        PartyOrgans.PartyOrgan organ,
        uint256 x,
        uint256 y,
        uint8 decimals
    ) external {
        self.numericalMatrix[x][organ][y].decimals = decimals;
    }

    function setTheme(PairOfMatricies storage self, bool isCategorical, uint256 x, string memory theme) external {
        self.themes[isCategorical][x] = theme;
    }

    function setStatement(
        PairOfMatricies storage self,
        bool isCategorical,
        uint256 x,
        uint256 y,
        string memory statement
    ) external {
        if (bytes(self.themes[isCategorical][x]).length == 0) {
            revert NoThemeSet(isCategorical, x);
        }
        self.statements[isCategorical][y] = statement;
    }
}
