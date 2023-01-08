extends Node

var is_debug = true

var INITIAL_CONVERSION_RATE_1 = 0.01
var INITIAL_CONVERSION_RATE_2 = 0.01
var INITIAL_OFFLINE_CONVERSION_RATE = 0.01

var INITIAL_ENEMY_CONVERSION_RATE_1 = 0.035
var INITIAL_ENEMY_CONVERSION_RATE_2 = 0.035
var INITIAL_ENEMY_OFFLINE_CONVERSION_RATE = 0.035

var GLOBAL_CONVERT_RATE = 0.01
var GLOBAL_ENEMY_CONVERT_RATE = 0.01

var START_FLAT_BOOST = 2.0

var EASY_DIFFICULTY = 0.5
var NORMAL_DIFFICULTY = 1.0
var HARD_DIFFICULTY = 1.1

var AUTOSAVE_FILENAME = "user://socialmediaety.autosave"

var INITIAL_DATA = {
    "Difficulty": NORMAL_DIFFICULTY,
    "Stress": 0.0,
    "Time": 1673208000,
    "Edicts": [1, 1],
    "Souls": 0,
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
                "Facepage": [0, 0, 243000000, INITIAL_CONVERSION_RATE_1, INITIAL_ENEMY_CONVERSION_RATE_1],
                "Twittly": [0, 0, 23000000, INITIAL_CONVERSION_RATE_2, INITIAL_ENEMY_CONVERSION_RATE_2],
                "Both": [1, 0, 56000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2), 1 - (1 - INITIAL_ENEMY_CONVERSION_RATE_1) * (1 - INITIAL_ENEMY_CONVERSION_RATE_2)],
                "Offline": [0, 0, 49000000, INITIAL_OFFLINE_CONVERSION_RATE, INITIAL_ENEMY_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
            "TentDefense": 0.995,
            "HarvestedToday": 0,
            "Boosts": [],
            "Banned": {},
        },
        "SouthAmerica": {
            "Categories": {
                "Facepage": [0, 0, 350000000, INITIAL_CONVERSION_RATE_1, INITIAL_ENEMY_CONVERSION_RATE_1],
                "Twittly": [0, 0, 75000000, INITIAL_CONVERSION_RATE_2, INITIAL_ENEMY_CONVERSION_RATE_2],
                "Both": [0, 0, 30000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2), 1 - (1 - INITIAL_ENEMY_CONVERSION_RATE_1) * (1 - INITIAL_ENEMY_CONVERSION_RATE_2)],
                "Offline": [0, 0, 274000000, INITIAL_OFFLINE_CONVERSION_RATE, INITIAL_ENEMY_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
            "TentDefense": 0.995,
            "HarvestedToday": 0,
            "Boosts": [],
            "Banned": {},
        },
        "Europe": {
            "Categories": {
                "Facepage": [0, 0, 363000000, INITIAL_CONVERSION_RATE_1, INITIAL_ENEMY_CONVERSION_RATE_1],
                "Twittly": [0, 0, 15000000, INITIAL_CONVERSION_RATE_2, INITIAL_ENEMY_CONVERSION_RATE_2],
                "Both": [0, 1, 45000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2), 1 - (1 - INITIAL_ENEMY_CONVERSION_RATE_1) * (1 - INITIAL_ENEMY_CONVERSION_RATE_2)],
                "Offline": [0, 0, 326000000, INITIAL_OFFLINE_CONVERSION_RATE, INITIAL_ENEMY_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
            "TentDefense": 0.995,
            "HarvestedToday": 0,
            "Boosts": [],
            "Banned": {},
        },
        "Oceania": {
            "Categories": {
                "Facepage": [0, 0, 24000000, INITIAL_CONVERSION_RATE_1, INITIAL_ENEMY_CONVERSION_RATE_1],
                "Twittly": [0, 0, 2000000, INITIAL_CONVERSION_RATE_2, INITIAL_ENEMY_CONVERSION_RATE_2],
                "Both": [0, 0, 6000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2), 1 - (1 - INITIAL_ENEMY_CONVERSION_RATE_1) * (1 - INITIAL_ENEMY_CONVERSION_RATE_2)],
                "Offline": [0, 0, 12000000, INITIAL_OFFLINE_CONVERSION_RATE, INITIAL_ENEMY_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
            "TentDefense": 0.995,
            "HarvestedToday": 0,
            "Boosts": [],
            "Banned": {},
        },
        "Africa": {
            "Categories": {
                "Facepage": [0, 0, 234000000, INITIAL_CONVERSION_RATE_1, INITIAL_ENEMY_CONVERSION_RATE_1],
                "Twittly": [0, 0, 10000000, INITIAL_CONVERSION_RATE_2, INITIAL_ENEMY_CONVERSION_RATE_2],
                "Both": [0, 0, 13000000, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2), 1 - (1 - INITIAL_ENEMY_CONVERSION_RATE_1) * (1 - INITIAL_ENEMY_CONVERSION_RATE_2)],
                "Offline": [0, 0, 1164000000, INITIAL_OFFLINE_CONVERSION_RATE, INITIAL_ENEMY_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
            "TentDefense": 0.995,
            "HarvestedToday": 0,
            "Boosts": [],
            "Banned": {},
        },
        "Asia": {
            "Categories": {
                "V Kontent": [0, 0, 450000000, INITIAL_CONVERSION_RATE_1, INITIAL_ENEMY_CONVERSION_RATE_1],
                "WeTalk": [0, 0, 1240000000, INITIAL_CONVERSION_RATE_2, INITIAL_ENEMY_CONVERSION_RATE_2],
                "Both": [0, 0, 0, 1 - (1 - INITIAL_CONVERSION_RATE_1) * (1 - INITIAL_CONVERSION_RATE_2), 1 - (1 - INITIAL_ENEMY_CONVERSION_RATE_1) * (1 - INITIAL_ENEMY_CONVERSION_RATE_2)],
                "Offline": [0, 0, 3053000000, INITIAL_OFFLINE_CONVERSION_RATE, INITIAL_ENEMY_OFFLINE_CONVERSION_RATE],
            },
            "PriceScale": 1.0,
            "FollowerDefense": 0.995,
            "TentDefense": 0.995,
            "HarvestedToday": 0,
            "Boosts": [],
            "Banned": {},
        },
    }
}

var data = INITIAL_DATA.duplicate(true)

func load_autosave():
    var file = FileAccess.open(AUTOSAVE_FILENAME, FileAccess.READ)
    data = file.get_var()


func has_autosave():
    return FileAccess.file_exists(AUTOSAVE_FILENAME)


func save():
    var file = FileAccess.open(AUTOSAVE_FILENAME, FileAccess.WRITE)
    file.store_var(data)
