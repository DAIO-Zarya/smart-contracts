// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { YCell } from './libraries/YCell.sol';
import { XCell } from './libraries/XCell.sol';
import { IOpinionMatrix } from './interfaces/IOpinionMatrix.sol';

contract OpinionMatrix is IOpinionMatrix {
    using XCell for XCell.TwosComplementXCell;
    using YCell for YCell.RLEYCell;

    uint256 public maxXCellsXIndex;
    uint256 public maxXCellsYIndex;

    uint256 public maxYCellsXIndex;
    uint256 public maxYCellsYIndex;

    mapping(uint256 => mapping(uint256 => XCell.TwosComplementXCell)) internal _xCells;
    mapping(uint256 => mapping(uint256 => YCell.RLEYCell)) internal _yCells;

    event XCellAdded(uint256 xIndex, uint256 yIndex, int24 value);
    event YCellAdded(uint256 xIndex, uint256 yIndex, uint256 value);

    event ScaleSet(uint256 xIndex, uint256 yIndex, uint8 numerator, uint8 denominator);
    event CategoriesSet(uint256 xIndex, uint256 yIndex, uint256[] categories);

    event XCellUpdated(uint256 xIndex, uint256 yIndex, int24 value);
    event YCellUpdated(uint256 xIndex, uint256 yIndex, uint256 value);

    error InvalidXIndex();
    error InvalidYIndex();

    constructor(address accessManager) {}

    function initializeXCell(
        uint256 xIndex,
        uint256 yIndex,
        uint8 numerator,
        uint8 denominator,
        int24 firstValue
    ) external virtual override {
        if (xIndex > maxXCellsXIndex) {
            maxXCellsXIndex = xIndex;
        }
        if (yIndex > maxXCellsYIndex) {
            maxXCellsYIndex = yIndex;
        }

        XCell.TwosComplementXCell storage xCell = _xCells[xIndex][yIndex];
        xCell.setScale(XCell.Scale(numerator, denominator, false));
        xCell.add(firstValue);
        xCell.row = xIndex;
        xCell.column = yIndex;
        emit XCellAdded(xIndex, yIndex, firstValue);
    }

    function updateXCell(uint256 xIndex, uint256 yIndex, int24 value) external virtual override {
        if (xIndex > maxXCellsXIndex) {
            revert InvalidXIndex();
        }
        if (yIndex > maxXCellsYIndex) {
            revert InvalidYIndex();
        }

        _xCells[xIndex][yIndex].add(value);
        emit XCellUpdated(xIndex, yIndex, value);
    }

    function initializeYCell(
        uint256 xIndex,
        uint256 yIndex,
        uint256[] memory categories,
        uint256 firstValue
    ) external virtual override {
        if (xIndex > maxYCellsXIndex) {
            maxYCellsXIndex = xIndex;
        }
        if (yIndex > maxYCellsYIndex) {
            maxYCellsYIndex = yIndex;
        }

        YCell.RLEYCell storage yCell = _yCells[xIndex][yIndex];
        yCell.setCategories(categories);
        yCell.add(firstValue);
        yCell.row = xIndex;
        yCell.column = yIndex;
        emit YCellAdded(xIndex, yIndex, firstValue);
    }

    function updateYCell(uint256 xIndex, uint256 yIndex, uint256 value) external virtual override {
        if (xIndex > maxYCellsXIndex) {
            revert InvalidXIndex();
        }
        if (yIndex > maxYCellsYIndex) {
            revert InvalidYIndex();
        }

        _yCells[xIndex][yIndex].add(value);
        emit YCellUpdated(xIndex, yIndex, value);
    }

    function getXCellSamples(uint256 xIndex, uint256 yIndex) external view virtual override returns (int24[] memory result) {
        uint256 length = _xCells[xIndex][yIndex].length();
        result = new int24[](length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = _xCells[xIndex][yIndex].at(i);
        }
    }

    function getYCellSamples(uint256 xIndex, uint256 yIndex) external view virtual override returns (uint256[] memory) {
        return _yCells[xIndex][yIndex].getValues();
    }
}
