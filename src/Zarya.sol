// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { Checkpoints } from '@openzeppelin/contracts/utils/structs/Checkpoints.sol';
import { EnumerableSet } from '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

import { Codes } from './libraries/Codes.sol';

contract Zarya {
    using Codes for Codes.Region;
    using Checkpoints for Checkpoints.Trace224;
    using EnumerableSet for EnumerableSet.UintSet;

    struct CategoricalCell {
        Checkpoints.Trace224 categoricalSample;
        EnumerableSet.UintSet allowedCategories;
        string xDescription;
        string yDescription;
    }

    struct NumericalCell {
        Checkpoints.Trace224 numericalSample;
        uint8 decimals;
        string xDescription;
        string yDescription;
    }

    mapping(uint256 x => mapping(uint256 y => CategoricalCell cell)) internal _categoricalMatrix;
    mapping(uint256 x => mapping(uint256 y => NumericalCell cell)) internal _numericalMatrix;

    error CategoryAlreadyExists(uint64 category);
    error InvalidCategory(uint64 category);

    event ValueAdded(uint256 indexed x, uint256 indexed y, uint64 value, address indexed author);
    event CategoryAdded(uint256 indexed x, uint256 indexed y, uint64 category);

    function _addValue(
        uint256 x,
        uint256 y,
        uint64 value,
        address author,
        bool isCategorical
    ) internal {
        if (isCategorical) {
            if (!_categoricalMatrix[x][y].allowedCategories.contains(value)) {
                revert InvalidCategory(value);
            }
            _categoricalMatrix[x][y].categoricalSample.push(uint32(block.timestamp), uint224(bytes28(abi.encodePacked(author, value))));
        } else {
            _numericalMatrix[x][y].numericalSample.push(uint32(block.timestamp), uint224(bytes28(abi.encodePacked(author, value))));
        }
        emit ValueAdded(x, y, value, author);
    }

    function _addCategory(
        uint256 x,
        uint256 y,
        uint64 category
    ) internal {
        if (!_categoricalMatrix[x][y].allowedCategories.add(category)) {
            revert CategoryAlreadyExists(category);
        }
        emit CategoryAdded(x, y, category);
    }

    function _setNumericalCellDescription(
        uint256 x,
        uint256 y,
        string memory xDescription,
        string memory yDescription
    ) external {
        _numericalMatrix[x][y].xDescription = xDescription;
        _numericalMatrix[x][y].yDescription = yDescription;
    }

    function _setCategoricalCellDescription(
        uint256 x,
        uint256 y,
        string memory xDescription,
        string memory yDescription
    ) external {
        _categoricalMatrix[x][y].xDescription = xDescription;
        _categoricalMatrix[x][y].yDescription = yDescription;
    }

    function _setDecimals(
        uint256 x,
        uint256 y,
        uint8 decimals
    ) external {
        _numericalMatrix[x][y].decimals = decimals;
    }

    function findCategoricalValue(uint256 x, uint256 y, uint32 timestamp) external view returns (uint224) {
        return _categoricalMatrix[x][y].categoricalSample.upperLookup(timestamp);
    }

    function findNumericalValue(uint256 x, uint256 y, uint32 timestamp) external view returns (uint224) {
        return _numericalMatrix[x][y].numericalSample.upperLookup(timestamp);
    }

    function isCategoryAllowed(uint256 x, uint256 y, uint64 category) external view returns (bool) {
        return _categoricalMatrix[x][y].allowedCategories.contains(category);
    }

    // organ management operations

    // suggest new category into x,y point in categorical matrix

    // suggest new x,y point in numerical matrix

    // suggest new value to be added for categorical matrix cell

    // suggest new value to be added for numerical matrix cell
}