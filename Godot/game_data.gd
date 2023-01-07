extends Node

var is_debug = true

var data = {
    "Edicts": [1, 1],
    "Souls": 100000 if is_debug else 0,
    "Acolytes": [],
    "Upgrades": [
        ["Acolyte", 100, false],
        ["Acolyte", 1000, false],
        ["Spambots I", 2000, false],
        ["Acolyte", 10000, false],
        ["Better Bribes", 50000, false],
        ["Acolyte", 100000, false],
        ["Spambots II", 200000, false],
        ["Acolyte", 1000000, false],
        ["Acolyte", 10000000, false],
        ["Spambots III", 20000000, false],
        ["Cheaper Bribes", 50000000, false],
        ["Acolyte", 100000000, false],
        ["Spambots IV", 500000000, false],
        ["Eat Planet", 3000000000, false],
    ],
    "Regions": {
        "NorthAmerica": {
            "Facepage": [0, 0, 243000000],
            "Twittly": [0, 0, 23000000],
            "Both": [1, 0, 56000000],
            "Offline": [0, 0, 49000000],
        },
        "SouthAmerica": {
            "Facepage": [0, 0, 350000000],
            "Twittly": [0, 0, 75000000],
            "Both": [0, 0, 30000000],
            "Offline": [0, 0, 274000000],
        },
        "Europe": {
            "Facepage": [0, 0, 363000000],
            "Twittly": [0, 0, 15000000],
            "Both": [0, 1, 45000000],
            "Offline": [0, 0, 326000000],
        },
        "Oceania": {
            "Facepage": [0, 0, 24000000],
            "Twittly": [0, 0, 2000000],
            "Both": [0, 0, 6000000],
            "Offline": [0, 0, 12000000],
        },
        "Africa": {
            "Facepage": [0, 0, 234000000],
            "Twittly": [0, 0, 10000000],
            "Both": [0, 0, 13000000],
            "Offline": [0, 0, 1164000000],
        },
        "Asia": {
            "V Kontent": [0, 0, 450000000],
            "WeTalk": [0, 0, 1240000000],
            "Both": [0, 0, 0],
            "Offline": [0, 0, 3053000000],
        },
    }
}
