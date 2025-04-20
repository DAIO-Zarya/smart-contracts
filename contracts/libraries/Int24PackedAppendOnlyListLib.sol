// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

library Int24PackedAppendOnlyListLib {

    struct TwosComplementInt24List {
        bytes data;
        uint256 lastIndex;
    }

    error OutOfBounds();

    function length(TwosComplementInt24List memory self) internal pure returns (uint256) {
        return self.lastIndex + 1;
    }

    function add(TwosComplementInt24List storage self, int24 value) internal {
        if (self.lastIndex * 3 + 3 > self.data.length) {
            bytes memory newData = new bytes(self.data.length + 3);
            for (uint256 i = 0; i < self.data.length; i++) {
                newData[i] = self.data[i];
            }
            self.data = newData;
        }

        uint256 offset = self.lastIndex * 3;
        self.data[offset] = bytes1(uint8(uint24(uint24(value) >> 16)));
        self.data[offset + 1] = bytes1(uint8(uint24(value) >> 8));
        self.data[offset + 2] = bytes1(uint8(uint24(value)));
        self.lastIndex++;
    }

    function at(TwosComplementInt24List memory self, uint256 index) internal pure returns (int24) {
        if (index * 3 + 3 > self.data.length) {
            revert OutOfBounds();
        }
        uint24 raw = ((uint24(uint8(self.data[index * 3])) << 16) |
            (uint24(uint8(self.data[index * 3 + 1])) << 8) |
            (uint24(uint8(self.data[index * 3 + 2]))));

        if ((raw & 0x800000) != 0) {
            return int24(int32(raw | 0xFF000000));
        } else {
            return int24(int32(uint32(raw)));
        }
    }
}
