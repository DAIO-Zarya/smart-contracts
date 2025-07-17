// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import {Regions} from "./Regions.sol";

library PartyOrgans {
    using Regions for Regions.Region;

    type PartyOrgan is bytes32;

    enum PartyOrganType {
        LocalSoviet,
        LocalGeneralAssembly,
        RegionalSoviet,
        RegionalConference,
        RegionalGeneralAssembly,
        Chairperson,
        CentralSoviet,
        Congress
    }

    string internal constant CONGRESS_POSTFIX = unicode"СЗД";
    string internal constant SOVIET_POSTFIX = unicode"СОВ";
    string internal constant CHAIRPERSON_POSTFIX = unicode"ПРЛ";
    string internal constant GENERAL_ASSEMBLY_POSTFIX = unicode"ОБС";
    string internal constant CONFERENCE_POSTFIX = unicode"КОН";

    error InvalidPartyOrganType(PartyOrganType organType);

    function from(PartyOrganType organType, Regions.Region region, uint256 number) internal pure returns (PartyOrgan) {
        string memory identifier = getPartyOrganIdentifier(organType, region, number);
        return PartyOrgan.wrap(keccak256(abi.encodePacked(identifier)));
    }

    function getPartyOrganIdentifier(PartyOrganType organType, Regions.Region region, uint256 number)
        internal
        pure
        returns (string memory)
    {
        if (organType == PartyOrganType.LocalSoviet) {
            return string(abi.encodePacked(Regions.toString(region), ".", number, ".", SOVIET_POSTFIX));
        } else if (organType == PartyOrganType.LocalGeneralAssembly) {
            return string(abi.encodePacked(Regions.toString(region), ".", number, ".", GENERAL_ASSEMBLY_POSTFIX));
        } else if (organType == PartyOrganType.RegionalSoviet) {
            return string(abi.encodePacked(Regions.toString(region), ".", SOVIET_POSTFIX));
        } else if (organType == PartyOrganType.RegionalConference) {
            return string(abi.encodePacked(Regions.toString(region), ".", CONFERENCE_POSTFIX));
        } else if (organType == PartyOrganType.RegionalGeneralAssembly) {
            return string(abi.encodePacked(Regions.toString(region), ".", GENERAL_ASSEMBLY_POSTFIX));
        } else if (organType == PartyOrganType.Chairperson) {
            return CHAIRPERSON_POSTFIX;
        } else if (organType == PartyOrganType.CentralSoviet) {
            return SOVIET_POSTFIX;
        } else if (organType == PartyOrganType.Congress) {
            return CONGRESS_POSTFIX;
        }
        revert InvalidPartyOrganType(organType);
    }
}
