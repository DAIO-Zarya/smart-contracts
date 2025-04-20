// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { Int24PackedAppendOnlyListLib } from './Int24PackedAppendOnlyListLib.sol';

library XCell {
    using Int24PackedAppendOnlyListLib for Int24PackedAppendOnlyListLib.TwosComplementInt24List;

    struct Scale {
        uint8 numerator;
        uint8 denominator;
        bool isScaleSet;
    }

    struct TwosComplementXCell {
        Int24PackedAppendOnlyListLib.TwosComplementInt24List samples;
        uint256 row;
        uint256 column;
        Scale scale;
    }

    error ScaleIsAlreadySet();
    error InvalidScaleDenominator();
    error InvalidScaleNumerator();

    function getRow(TwosComplementXCell storage self) internal view returns (uint256) {
        return self.row;
    }

    function getColumn(TwosComplementXCell storage self) internal view returns (uint256) {
        return self.column;
    }

    function setScale(TwosComplementXCell storage self, Scale memory scale) internal {
        if (self.scale.isScaleSet) {
            revert ScaleIsAlreadySet();
        }
        if (scale.numerator == 0) {
            revert InvalidScaleNumerator();
        }
        if (scale.denominator == 0) {
            revert InvalidScaleDenominator();
        }
        self.scale = scale;
        self.scale.isScaleSet = true;
    }

    function getScale(TwosComplementXCell storage self) internal view returns (Scale memory) {
        return self.scale;
    }

    function getSamplesCount(TwosComplementXCell storage self) internal view returns (uint256) {
        return self.samples.length();
    }

    function at(TwosComplementXCell storage self, uint256 index) internal view returns (int24) {
        return self.samples.at(index);
    }

    function length(TwosComplementXCell storage self) internal view returns (uint256) {
        return self.samples.length();
    }

    function add(TwosComplementXCell storage self, int24 value) internal {
        self.samples.add(value);
    }
}
