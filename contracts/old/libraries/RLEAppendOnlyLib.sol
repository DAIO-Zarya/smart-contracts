// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library RLEAppendOnlyLib {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    struct Entry {
        EnumerableSet.Bytes32Set contents;
        mapping(bytes32 => uint256) counts;
    }

    function add(Entry storage self, bytes32 value) internal {
        if (self.contents.add(value)) {
            self.counts[value] = 1;
        } else {
            self.counts[value]++;
        }
    }

    function getCount(Entry storage self, bytes32 value) internal view returns (uint256) {
        return self.counts[value];
    }

    function getTotalSize(Entry storage self) internal view returns (uint256 totalSize) {
        for (uint256 i = 0; i < self.contents.length(); i++) {
            bytes32 value = self.contents.at(i);
            totalSize += self.counts[value];
        }
    }
}