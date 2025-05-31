// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

interface IOpinionMatrix {
    function initializeXCell(uint256 xIndex, uint256 yIndex, uint8 numerator, uint8 denominator, int24 firstValue) external;

    function updateXCell(uint256 xIndex, uint256 yIndex, int24 value) external;

    function initializeYCell(uint256 xIndex, uint256 yIndex, uint256[] memory categories, uint256 firstValue) external;

    function updateYCell(uint256 xIndex, uint256 yIndex, uint256 value) external;

    function getXCellSamples(uint256 xIndex, uint256 yIndex) external view returns (int24[] memory result);

    function getYCellSamples(uint256 xIndex, uint256 yIndex) external view returns (uint256[] memory);
}
