// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { SafeCast } from '@openzeppelin/contracts/utils/math/SafeCast.sol';

library Int24PackedAppendOnlyListLib {
    struct TwosComplementInt24List {
        bytes data; // Packed int24 values (3 bytes each).
        bytes authors; // Packed addresses (20 bytes each).
        bytes timestamps; // Packed timestamps (8 bytes each).
        uint256 lastIndex;
    }

    error OutOfBounds();

    function length(TwosComplementInt24List memory self) internal pure returns (uint256) {
        return self.lastIndex + 1;
    }

    function add(TwosComplementInt24List storage self, int24 value, address author) internal {
        // Batch allocate and avoid redundant copying for `data`.
        if (self.lastIndex * 3 + 3 > self.data.length) {
            uint256 newLength = self.data.length == 0 ? 96 : self.data.length * 2; // Start with 96 bytes or double the size.
            bytes memory newData = new bytes(newLength);
            for (uint256 i = 0; i < self.data.length; i++) {
                newData[i] = self.data[i];
            }
            self.data = newData;
        }

        // Batch allocate and avoid redundant copying for `authors`.
        if (self.lastIndex * 20 + 20 > self.authors.length) {
            uint256 newLength = self.authors.length == 0 ? 640 : self.authors.length * 2; // Start with 640 bytes or double the size.
            bytes memory newAuthors = new bytes(newLength);
            for (uint256 i = 0; i < self.authors.length; i++) {
                newAuthors[i] = self.authors[i];
            }
            self.authors = newAuthors;
        }

        // Batch allocate and avoid redundant copying for `timestamps`.
        if (self.lastIndex * 8 + 8 > self.timestamps.length) {
            uint256 newLength = self.timestamps.length == 0 ? 256 : self.timestamps.length * 2; // Start with 256 bytes or double the size.
            bytes memory newTimestamps = new bytes(newLength);
            for (uint256 i = 0; i < self.timestamps.length; i++) {
                newTimestamps[i] = self.timestamps[i];
            }
            self.timestamps = newTimestamps;
        }

        uint256 offset = self.lastIndex * 3;
        self.data[offset] = bytes1(uint8(uint24(uint24(value) >> 16)));
        self.data[offset + 1] = bytes1(uint8(uint24(value) >> 8));
        self.data[offset + 2] = bytes1(uint8(uint24(value)));

        // Add author.
        offset = self.lastIndex * 20;
        for (uint256 i = 0; i < 20; i++) {
            self.authors[offset + i] = bytes1(uint8(uint160(author) >> (8 * (19 - i))));
        }

        // Add timestamp.
        offset = self.lastIndex * 8;
        uint256 timestamp = block.timestamp;
        for (uint256 i = 0; i < 8; i++) {
            self.timestamps[offset + i] = bytes1(uint8(timestamp >> (8 * (7 - i))));
        }

        self.lastIndex++;
    }

    function at(
        TwosComplementInt24List memory self,
        uint256 index
    ) internal pure returns (int24 value, address author, uint256 timestamp) {
        if (
            index * 3 + 3 > self.data.length || index * 20 + 20 > self.authors.length || index * 8 + 8 > self.timestamps.length
        ) {
            revert OutOfBounds();
        }

        // Retrieve int24 value.
        uint24 raw = ((uint24(uint8(self.data[index * 3])) << 16) |
            (uint24(uint8(self.data[index * 3 + 1])) << 8) |
            (uint24(uint8(self.data[index * 3 + 2]))));
        if ((raw & 0x800000) != 0) {
            value = int24(int32(raw | 0xFF000000));
        } else {
            value = int24(int32(uint32(raw)));
        }

        // Retrieve author.
        uint256 authorOffset = index * 20;
        uint160 authorRaw;
        for (uint256 i = 0; i < 20; i++) {
            authorRaw |= uint160(uint8(self.authors[authorOffset + i])) << (8 * (19 - i));
        }
        author = address(authorRaw);

        // Retrieve timestamp.
        uint256 timestampOffset = index * 8; // Adjusted to 8 bytes per timestamp.
        for (uint256 i = 0; i < 8; i++) {
            timestamp |= uint256(uint8(self.timestamps[timestampOffset + i])) << (8 * (7 - i));
        }
    }
}
