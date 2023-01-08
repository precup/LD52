extends Node

var is_debug = true

var INITIAL_CONVERSION_RATE_1 = 0.01
var INITIAL_CONVERSION_RATE_2 = 0.01
var INITIAL_OFFLINE_CONVERSION_RATE = 0.01

var data = {
    "Time": 1673208000,
    "Edicts": [1, 1],
    "Souls": 10000000000 if is_debug else 0,
    "Acolytes": [],
    "Upgrades": [
        # Name, cost, bought, displayed
        ["Acolyte", 100, false, false],
        ["Acolyte", 1000, false, false],
        ["Spambots I", 2000, false, false],
        ["Acolyte", 10000, false, false],
        ["Shop Discounts", 50000, false, false],
        ["Acolyte", 100000, false, false],
        ["Spambots II", 200000, false, false],
        ["Acolyte", 1000000, false, false],
        ["Acolyte", 10000000, false, false],
        ["Spambots III", 20000000, false, false],
        ["Shop Discounts", 50000000, false, false],
        ["Acolyte", 100000000, false, false],
        ["Spambots IV", 500000000, false, false],
        ["Eat Planet", 3000000000, false, false],
    ],
    "Regions": {
        "NorthAmerica": {
            "Categories": {
                "Facepage": [0, 0, 243000000, INITIAL_CONVERSION_RATE_1],
                "Twittly": [0, 0, 23000000, INITIAL_CONVERSION_RATE_2],
                "Both": [1000 if is_debug else 1, 0, 56000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2)],
                "Offline": [0, 0, 49000000, INITIAL_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
        },
        "SouthAmerica": {
            "Categories": {
                "Facepage": [0, 0, 350000000, INITIAL_CONVERSION_RATE_1],
                "Twittly": [0, 0, 75000000, INITIAL_CONVERSION_RATE_2],
                "Both": [0, 0, 30000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2)],
                "Offline": [0, 0, 274000000, INITIAL_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
        },
        "Europe": {
            "Categories": {
                "Facepage": [0, 0, 363000000, INITIAL_CONVERSION_RATE_1],
                "Twittly": [0, 0, 15000000, INITIAL_CONVERSION_RATE_2],
                "Both": [0, 1, 45000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2)],
                "Offline": [0, 0, 326000000, INITIAL_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
        },
        "Oceania": {
            "Categories": {
                "Facepage": [0, 0, 24000000, INITIAL_CONVERSION_RATE_1],
                "Twittly": [0, 0, 2000000, INITIAL_CONVERSION_RATE_2],
                "Both": [0, 0, 6000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2)],
                "Offline": [0, 0, 12000000, INITIAL_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
        },
        "Africa": {
            "Categories": {
                "Facepage": [0, 0, 234000000, INITIAL_CONVERSION_RATE_1],
                "Twittly": [0, 0, 10000000, INITIAL_CONVERSION_RATE_2],
                "Both": [0, 0, 13000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2)],
                "Offline": [0, 0, 1164000000, INITIAL_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
        },
        "Asia": {
            "Categories": {
                "V Kontent": [0, 0, 450000000, INITIAL_CONVERSION_RATE_1],
                "WeTalk": [0, 0, 1240000000, INITIAL_CONVERSION_RATE_2],
                "Both": [0, 0, 0, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2)],
                "Offline": [0, 0, 3053000000, INITIAL_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
        },
    }
}
