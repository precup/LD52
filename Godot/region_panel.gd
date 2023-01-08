extends PanelContainer

signal shop_button
signal harvest

@onready var ALL_LABEL = $MarginContainer/VBoxContainer/HBoxContainer4/Label4
@onready var ALL_EYE_LABEL = $MarginContainer/VBoxContainer/HBoxContainer4/Label5
@onready var ALL_TENT_LABEL = $MarginContainer/VBoxContainer/HBoxContainer4/Label6
@onready var ALL_OTHER_LABEL = $MarginContainer/VBoxContainer/HBoxContainer4/Label7

@onready var SOC1_LABEL = $MarginContainer/VBoxContainer/HBoxContainer5/Label4
@onready var SOC1_EYE_LABEL = $MarginContainer/VBoxContainer/HBoxContainer5/Label5
@onready var SOC1_TENT_LABEL = $MarginContainer/VBoxContainer/HBoxContainer5/Label6
@onready var SOC1_OTHER_LABEL = $MarginContainer/VBoxContainer/HBoxContainer5/Label7

@onready var SOC2_LABEL = $MarginContainer/VBoxContainer/HBoxContainer6/Label4
@onready var SOC2_EYE_LABEL = $MarginContainer/VBoxContainer/HBoxContainer6/Label5
@onready var SOC2_TENT_LABEL = $MarginContainer/VBoxContainer/HBoxContainer6/Label6
@onready var SOC2_OTHER_LABEL = $MarginContainer/VBoxContainer/HBoxContainer6/Label7

@onready var ACOLYTE_ROW = $MarginContainer/VBoxContainer/HBoxContainer8
@onready var ACOLYTE_MINUS = $MarginContainer/VBoxContainer/HBoxContainer8/Label5
@onready var ACOLYTE_PLUS = $MarginContainer/VBoxContainer/HBoxContainer8/Label7
@onready var ACOLYTE_LABEL = $MarginContainer/VBoxContainer/HBoxContainer8/Label6

@onready var HARVEST_LOW_BUTTON = $MarginContainer/VBoxContainer/HBoxContainer7/Label5
@onready var HARVEST_MID_BUTTON = $MarginContainer/VBoxContainer/HBoxContainer7/Label6
@onready var HARVEST_HIGH_BUTTON = $MarginContainer/VBoxContainer/HBoxContainer7/Label7


func _ready():
    update_text()


func _process(delta):
    update_text()


func _on_label_4_pressed():
    emit_signal("shop_button", name)

var harvest_amounts = [0, 0, 0]

func update_text():
    var data = GameData.data["Regions"][name]["Categories"]
    var totals = [0, 0, 0]
    for category in data:
        for i in range(3):
            totals[i] += data[category][i]
    ALL_EYE_LABEL.text = Utils.compress(totals[0])
    ALL_TENT_LABEL.text = Utils.compress(totals[1])
    ALL_OTHER_LABEL.text = Utils.compress(totals[2])
    
    var social_index = 0
    for social in ["Facepage", "Twittly", "V Kontent", "WeTalk"]:
        if social not in data:
            continue
        var amounts = [0, 0, 0]
        for k in range(3):
            amounts[k] += data[social][k]
            amounts[k] += data["Both"][k]
        if social_index == 0:
            SOC1_LABEL.text = social
            SOC1_EYE_LABEL.text = Utils.compress(amounts[0])
            SOC1_TENT_LABEL.text = Utils.compress(amounts[1])
            SOC1_OTHER_LABEL.text = Utils.compress(amounts[2])
        else:
            SOC2_LABEL.text = social
            SOC2_EYE_LABEL.text = Utils.compress(amounts[0])
            SOC2_TENT_LABEL.text = Utils.compress(amounts[1])
            SOC2_OTHER_LABEL.text = Utils.compress(amounts[2])
        social_index += 1
    
    var harvest_power = 0
    var harvest_div = totals[0]
    while harvest_div >= 10:
        harvest_div /= 10
        harvest_power += 1
    harvest_power = max(0, harvest_power - 2)
    var mid_harvest = pow(10, harvest_power + 1)
    harvest_amounts[0] = mid_harvest / 10
    harvest_amounts[1] = mid_harvest
    harvest_amounts[2] = mid_harvest * 10
    HARVEST_LOW_BUTTON.text = Utils.compress(harvest_amounts[0])
    HARVEST_LOW_BUTTON.disabled = totals[0] < harvest_amounts[0] + 1
    HARVEST_MID_BUTTON.text = Utils.compress(harvest_amounts[1])
    HARVEST_MID_BUTTON.disabled = totals[0] < harvest_amounts[1] + 1
    HARVEST_HIGH_BUTTON.text = Utils.compress(harvest_amounts[2])
    HARVEST_HIGH_BUTTON.disabled = totals[0] < harvest_amounts[2] + 1
    
    var acolyte_count = 0
    var unused_acolyte_count = 0
    for location in GameData.data["Acolytes"]:
        if location == name:
            acolyte_count += 1
        elif location == "":
            unused_acolyte_count += 1
            
    ACOLYTE_LABEL.text = str(acolyte_count)
    ACOLYTE_ROW.visible = len(GameData.data["Acolytes"]) > 0
    ACOLYTE_MINUS.disabled = acolyte_count == 0
    ACOLYTE_PLUS.disabled = unused_acolyte_count == 0


func _on_label_5_pressed():
    emit_signal("harvest", name, harvest_amounts[0])


func _on_label_6_pressed():
    emit_signal("harvest", name, harvest_amounts[1])


func _on_label_7_pressed():
    emit_signal("harvest", name, harvest_amounts[2])


func _on_minus_pressed():
    for i in range(len(GameData.data["Acolytes"])):
        if GameData.data["Acolytes"][i] == name:
            GameData.data["Acolytes"][i] = ""
            break


func _on_plus_pressed():
    for i in range(len(GameData.data["Acolytes"])):
        if GameData.data["Acolytes"][i] == "":
            GameData.data["Acolytes"][i] = name
            break
