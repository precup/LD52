extends MarginContainer

@onready var BOOST1_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer/MarginContainer/Button
@onready var BOOST2_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer2/MarginContainer/Button
@onready var BOOST3_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer3/MarginContainer/Button
@onready var NERF1_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer/MarginContainer2/Button
@onready var NERF2_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer2/MarginContainer2/Button
@onready var NERF3_BUTTON = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HSplitContainer3/MarginContainer2/Button

var reg = "NorthAmerica"
func get_price(region, num):
    return 100000

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


func _on_button2_pressed():
    GameData.data["Souls"] -= get_price(reg, -1)


func _on_button3_pressed():
    GameData.data["Souls"] -= get_price(reg, 2)


func _on_button4_pressed():
    GameData.data["Souls"] -= get_price(reg, -2)


func _on_button5_pressed():
    GameData.data["Souls"] -= get_price(reg, 3)


func _on_button6_pressed():
    GameData.data["Souls"] -= get_price(reg, -3)
