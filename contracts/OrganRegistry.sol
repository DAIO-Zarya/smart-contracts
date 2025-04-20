// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import { EnumerableSet } from '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

import { Codes } from './libraries/Codes.sol';

contract OrganRegistry {
    using Codes for Codes.Region;
    using EnumerableSet for EnumerableSet.AddressSet;

    enum OrganType {
        LOCAL_GENERAL_ASSEMBLY,
        LOCAL_SOVIET,
        REGIONAL_GENERAL_ASSEMBLY,
        REGIONAL_SOVIET,
        REGIONAL_CONFERENCE,
        CONGRESS,
        CHAIRPERSON,
        CENTRAL_SOVIET
    }

    struct Organ {
        bool established;
        string name;
        EnumerableSet.AddressSet members;
        mapping(uint256 => mapping(uint256 => bool)) allowedCoordinates;
    }

    uint256 public localOrgansIdsGenerator;
    mapping(bytes32 codeHash => Organ organ) internal _organs;

    event OrganAdded(string indexed name, OrganType indexed organType, Codes.Region indexed region);

    error OrganAlreadyExists(string name);

    function addOrgan(OrganType organType, Codes.Region region) external {
        localOrgansIdsGenerator++;
        string memory name;
        if (organType == OrganType.LOCAL_GENERAL_ASSEMBLY) {
            name = region.localGeneralAssembly(localOrgansIdsGenerator);
        } else if (organType == OrganType.LOCAL_SOVIET) {
            name = region.localSoviet(localOrgansIdsGenerator);
        } else if (organType == OrganType.REGIONAL_GENERAL_ASSEMBLY) {
            name = region.regionalGeneralAssembly();
        } else if (organType == OrganType.REGIONAL_SOVIET) {
            name = region.regionalSoviet();
        } else if (organType == OrganType.REGIONAL_CONFERENCE) {
            name = region.regionalConference();
        } else if (organType == OrganType.CONGRESS) {
            name = Codes.congress();
        } else if (organType == OrganType.CHAIRPERSON) {
            name = Codes.chairperson();
        } else if (organType == OrganType.CENTRAL_SOVIET) {
            name = Codes.centralSoviet();
        }
        Organ storage organ = _organs[keccak256(abi.encodePacked(name))];
        if (organ.established) {
            revert OrganAlreadyExists(name);
        }
        organ.name = name;
        organ.established = true;
        emit OrganAdded(name, organType, region);
    }
}
