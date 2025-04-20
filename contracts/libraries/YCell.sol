// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { RLEAppendOnlyLib } from './libraries/RLEAppendOnlyLib.sol';

library YCell {
    struct RLEYCell {
        uint256 row;
        uint256 column;
        bool areCategoriesSet;
        RLEAppendOnlyLib.Entry samples;
        mapping(uint256 => bool) categories;
    }

    error CategoriesAlreadySet();
    error InvalidCategory();

    function add(RLEYCell storage self, uint256 value) internal {
        if (!self.categories[value]) {
            revert InvalidCategory();
        }
        RLEAppendOnlyLib.add(self.samples, bytes32(value));
    }

    function setCategories(RLEYCell storage self, uint256[] memory categories) internal {
        if (self.areCategoriesSet) {
            revert CategoriesAlreadySet();
        }
        for (uint256 i = 0; i < categories.length; i++) {
            categories[i] = true;
        }
        self.areCategoriesSet = true;
    }

    function getCategories(RLEYCell storage self) internal view returns (uint256[] memory result) {
        uint256 length = self.samples.contents.length();
        result = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = uint256(self.samples.contents.at(i));
        }
    }

    function getValues(RLEYCell storage self) internal view returns (uint256[] memory result) {
        uint256 totalSize = self.samples.getTotalSize();
        result = new uint256[](totalSize);
        uint256 length = self.samples.contents.length();
        for (uint256 i = 0; i < length; i++) {
            bytes32 value = self.samples.contents.at(i);
            uint256 count = self.samples.getCount(value);
            for (uint256 j = 0; j < count; j++) {
                result[i * count + j] = uint256(value);
            }
        }
    }

    function getRow(RLEYCell storage self) internal view returns (uint256) {
        return self.row;
    }

    function getColumn(RLEYCell storage self) internal view returns (uint256) {
        return self.column;
    }

    function getSamplesCount(RLEYCell storage self) internal view returns (uint256) {
        return self.samples.getTotalSize();
    }
}
