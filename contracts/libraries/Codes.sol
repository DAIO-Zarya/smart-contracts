// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

library Codes {
    // https://www.consultant.ru/document/cons_doc_LAW_287480/8f29ebe5f8d588f758502bc41ff2da96a45fc497/
    enum Region {
        ADYGEA_REPUBLIC = 01,
        BASHKTORTOSTAN_REPUBLIC = 02,
        BURYATIA_REPUBLIC = 03,
        ALTAY_REPUBLIC = 04,
        DAGHESTAN_REPUBLIC = 05,
        INGUSHETIA_REPUBLIC = 06,
        KABARDINO_BALKAR_REPUBLIC = 07,
        KALMYKIYA_REPUBLIC = 08,
        KARACHAY_CHERKESS_REPUBLIC = 09,
        KARELIA_REPUBLIC = 10,
        KOMI_REPUBLIC = 11,
        MARIY_EL_REPUBLIC = 12,
        MORDOVIA_REPUBLIC = 13,
        SAKHA_REPUBLIC_YAKUTIA = 14,
        NORTH_OSSETIA_ALANIA_REPUBLIC = 15,
        TATARSTAN_REPUBLIC = 16,
        TYVA_REPUBLIC = 17,
        UDMURTIA_REPUBLIC = 18,
        HAKASSIA_REPUBLIC = 19,
        CHECHEN_REPUBLIC = 95,
        CHUVASHIA_REPUBLIC = 21,
        KRYM_REPUBLIC = 82,
        ALTAYSKY_KRAI = 22,
        PERMSKY_KRAI = 59,
        PRIMORSKY_KRAI = 25,
        STAVROPOL_KRAI = 26,
        HABAROVSKY_KRAI = 27,
        AMURSKAYA_OBLAST = 28,
        ARCHANGELSKAYA_OBLAST = 29,
        ASTRAKHANSKAYA_OBLAST = 30,
        BELGORODSKAYA_OBLAST = 31,
        BRYANSKAYA_OBLAST = 32,
        VLADIMIRSKAYA_OBLAST = 33,
        VOLGOGRADSKAYA_OBLAST = 34,
        VOLOGODSKAYA_OBLAST = 35,
        VORONEZHSKAYA_OBLAST = 36,
        IVANOVSKAYA_OBLAST = 37,
        IRKUTSKAYA_OBLAST = 38,
        KALININGRADSKAYA_OBLAST = 39,
        KALUZHSKAYA_OBLAST = 40,
        KEMEROVSKAYA_OBLAST = 42,
        KIROVSKAYA_OBLAST = 43,
        KOSTROMSKAYA_OBLAST = 44,
        KURGANSKAYA_OBLAST = 45,
        KURSKAYA_OBLAST = 46,
        LENINGRADSKAYA_OBLAST = 47,
        LIPETSKAYA_OBLAST = 48,
        MAGADANSKAYA_OBLAST = 49,
        MOSKOVSKAYA_OBLAST_50 = 50,
        MOSKOVSKAYA_OBLAST_90 = 90,
        MURMANSKAYA_OBLAST = 51,
        ZABAIKALSKY_KRAI = 75,
        KAMCHATKSKY_KRAI = 41,
        KRASNODARSKY_KRAI_23 = 23,
        KRASNODARSKY_KRAI_93 = 93,
        KRASNOYARSKY_KRAI = 24,
        ORLOVSKAYA_OBLAST = 57,
        PENZENSKAYA_OBLAST = 58,
        PSKOVSKAYA_OBLAST = 60,
        ROSTOVSKAYA_OBLAST = 61,
        RYAZANSKAYA_OBLAST = 62,
        SAMARSKAYA_OBLAST = 63,
        SARATOVSKAYA_OBLAST = 64,
        SAKHALINSKAYA_OBLAST = 65,
        SVERDLOVSKAYA_OBLAST_66 = 66,
        SVERDLOVSKAYA_OBLAST_96 = 96,
        SMOLENSKAYA_OBLAST = 67,
        TAMBOVSKAYA_OBLAST = 68,
        TVERSKAYA_OBLAST = 69,
        TOMSKAYA_OBLAST = 70,
        TULSKAYA_OBLAST = 71,
        TUMENSKAYA_OBLAST = 72,
        ULYANOVSKAYA_OBLAST = 73,
        CHELYABINSKAYA_OBLAST = 74,
        YAROSLAVSKAYA_OBLAST = 76,
        NIZHEGORODSKAYA_OBLAST = 52,
        NOVGORODSKAYA_OBLAST = 53,
        NOVOSIBIRSKAYA_OBLAST = 54,
        OMSKAYA_OBLAST = 55,
        ORENBURGSKAYA_OBLAST = 56,
        MOSCOW_77 = 77,
        MOSCOW_97 = 97,
        MOSCOW_99 = 99,
        SAINT_PETERSBURG_78 = 78,
        SAINT_PETERSBURG_98 = 98,
        SEVASTOPOL = 92,
        EVREYSKAYA_AUTONOMNAYA_OBLAST = 79,
        NENETSKY_AUTONOMNY_OKRUG = 83,
        HANTY_MANSIYSKY_AUTONOMNY_OKRUG_YUGRA = 86,
        CHUKOTKSKY_AUTONOMNY_OKRUG = 87,
        YAMALO_NENETSKY_AUTONOMNY_OKRUG = 89,
        EXTERNAL_LANDS_88 = 88,
        EXTERNAL_LANDS_94 = 94,
        DONETSK_PEOPLE_REPUBLIC = 80,
        LUGANSK_PEOPLE_REPUBLIC = 81,
        HERSONSKAYA_OBLAST = 84,
        ZAPOROZHSKAYA_OBLAST = 85
    }

    string constant internal CONGRESS_POSTFIX = "СЗД";
    string constant internal SOVIET_POSTFIX = "СОВ";
    string constant internal CHAIRPERSON_POSTFIX = "ПРЛ";
    string constant internal GENERAL_MEETING_POSTFIX = "ОБС";
    string constant internal CONFERENCE_POSTFIX = "КОН";

    function localSoviet(Region region, uint256 number) internal pure returns (string memory) {
        return string(abi.encodePacked(uint256(region), ".", number, ".", SOVIET_POSTFIX));
    }

    function localGeneralMeeting(Region region, uint256 number) internal pure returns (string memory) {
        return string(abi.encodePacked(uint256(region), ".", number, ".", GENERAL_MEETING_POSTFIX));
    }

    function regionalSoviet(Region region) internal pure returns (string memory) {
        return string(abi.encodePacked(uint256(region), ".", SOVIET_POSTFIX));
    }

    function regionalConference(Region region) internal pure returns (string memory) {
        return string(abi.encodePacked(uint256(region), ".", CONFERENCE_POSTFIX));
    }

    function regionalGeneralMeeting(Region region) internal pure returns (string memory) {
        return string(abi.encodePacked(uint256(region), ".", GENERAL_MEETING_POSTFIX));
    }

    function chairperson() internal pure returns (string memory) {
        return CHAIRPERSON_POSTFIX;
    }

    function centralSoviet() internal pure returns (string memory) {
        return SOVIET_POSTFIX;
    }

    function congress() internal pure returns (string memory) {
        return CONGRESS_POSTFIX;
    }
}