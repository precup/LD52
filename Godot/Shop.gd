extends MarginContainer

@onready var BOOST1_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer/MarginContainer/Button
@onready var BOOST2_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer2/MarginContainer/Button
@onready var BOOST3_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer3/MarginContainer/Button
@onready var NERF1_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer/MarginContainer2/Button
@onready var NERF2_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer2/MarginContainer2/Button
@onready var NERF3_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer3/MarginContainer2/Button

func ten_floor(num):
    return pow(10, floor(log(num) / log(10)))


var reg = "NorthAmerica"
func get_price(region, num):
    var reg_data = GameData.data["Regions"][region]
    var soc = "V Kontent" if reg == "Asia" else "Facepage"
    if abs(num) == 2: 
        soc = "WeTalk" if reg == "Asia" else "Twittly"
    if abs(num) <= 2:
        var followers = reg_data["Categories"][soc][1 if num < 0 else 0] + reg_data["Categories"]["Both"][1 if num < 0 else 0]
        return ten_floor(max(1001, followers / 10)) * GameData.data["Regions"][region]["PriceScale"]
    else:
        var followers = 0
        for category in reg_data["Categories"]:
            followers += reg_data["Categories"][category][1 if num < 0 else 0]
        return ten_floor(max(10001, followers / 10)) * 1.5 * GameData.data["Regions"][region]["PriceScale"]


func display_region(region):
    reg = region
    visible = true
    var media1 = "Facepage" if region != "Asia" else "V Kontent"
    var media2 = "Twittly" if region != "Asia" else "WeTalk"
    BOOST1_BUTTON.text = "Boost yourself on %s - %s" % [media1, Utils.compress(get_price(region, 1))]
    BOOST2_BUTTON.text = "Boost yourself on %s - %s" % [media2, Utils.compress(get_price(region, 2))]
    BOOST3_BUTTON.text = "Get Endorsed - %s" % Utils.compress(get_price(region, 3))
    
    NERF1_BUTTON.text = "Insult your bro on %s - %s" % [media1, Utils.compress(get_price(region, -1))]
    NERF2_BUTTON.text = "Insult your bro on %s - %s" % [media2, Utils.compress(get_price(region, -2))]
    NERF3_BUTTON.text = "Buy anti-tentacle statements - %s" % Utils.compress(get_price(region, -3))


func _process(delta):
    BOOST1_BUTTON.disabled = get_price(reg, 1) > GameData.data["Souls"]
    BOOST2_BUTTON.disabled = get_price(reg, 2) > GameData.data["Souls"]
    BOOST3_BUTTON.disabled = get_price(reg, 3) > GameData.data["Souls"]
    
    NERF1_BUTTON.disabled = get_price(reg, -1) > GameData.data["Souls"]
    NERF2_BUTTON.disabled = get_price(reg, -2) > GameData.data["Souls"]
    NERF3_BUTTON.disabled = get_price(reg, -3) > GameData.data["Souls"]


func _on_margin_container_pressed():
    visible = false


func _on_button1_pressed():
    GameData.data["Souls"] -= get_price(reg, 1)
    GameData.data["Regions"][reg]["Boosts"].append(["Facepage" if reg != "Asia" else "V Kontent", 0, 21, 6.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Facepage" if reg != "Asia" else "V Kontent", 0, 7, 6.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 0, 21, 6.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 0, 7, 6.0, 0])
    if reg not in GameData.data["Ads"]:
        GameData.data["Ads"][reg] = 0
    GameData.data["Ads"][reg] = max(GameData.data["Ads"][reg], 21)
    visible = false


func _on_button2_pressed():
    GameData.data["Souls"] -= get_price(reg, -1)
    GameData.data["Regions"][reg]["Boosts"].append(["Facepage" if reg != "Asia" else "V Kontent", 1, 21, 0.1, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 1, 21, 0.25, 0])
    visible = false


func _on_button3_pressed():
    GameData.data["Souls"] -= get_price(reg, 2)
    GameData.data["Regions"][reg]["Boosts"].append(["Twittly" if reg != "Asia" else "WeTalk", 0, 21, 6.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Twittly" if reg != "Asia" else "WeTalk", 0, 7, 6.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 0, 21, 6.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 0, 7, 6.0, 0])
    visible = false


func _on_button4_pressed():
    GameData.data["Souls"] -= get_price(reg, -2)
    GameData.data["Regions"][reg]["Boosts"].append(["Twittly" if reg != "Asia" else "WeTalk", 1, 21, 0.1, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 1, 21, 0.25, 0])
    visible = false


func _on_button5_pressed():
    GameData.data["Souls"] -= get_price(reg, 3)
    GameData.data["Regions"][reg]["Boosts"].append(["Offline", 0, 21, 3.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Twittly" if reg != "Asia" else "WeTalk", 0, 21, 4.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Facepage" if reg != "Asia" else "V Kontent", 0, 21, 4.0, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 0, 21, 4.0, 0])
    visible = false


func _on_button6_pressed():
    GameData.data["Souls"] -= get_price(reg, -3)
    GameData.data["Regions"][reg]["Boosts"].append(["Offline", 1, 21, 0.1, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Twittly" if reg != "Asia" else "WeTalk", 1, 21, 0.1, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Facepage" if reg != "Asia" else "V Kontent", 1, 21, 0.1, 0])
    GameData.data["Regions"][reg]["Boosts"].append(["Both", 1, 21, 0.1, 0])
    visible = false
