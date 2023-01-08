extends PanelContainer

@onready var SOCIABILITY_OPTION = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer3/HSplitContainer/OptionButton
@onready var WORSHIP_OPTION = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer4/HSplitContainer/OptionButton
@onready var FOLLOWERS_LABEL = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer/HSplitContainer/Label2
@onready var TENT_LABEL = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer8/HSplitContainer/Label2
@onready var SOULS_LABEL = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer16/HSplitContainer/Label2
@onready var UNUSED_ACOLYTES_LABEL = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer5/HSplitContainer/Label2
@onready var SHOP_CONTAINER = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer12/ScrollContainer/VBoxContainer
@onready var STRESS_BAR: TextureProgressBar = $MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer7/HSplitContainer/OptionButton

func _ready():
    if len(GameData.data["Upgrades"]) != SHOP_CONTAINER.get_child_count():
        print("Incorrect number of upgrades")
    for i in range(len(GameData.data["Upgrades"])):
        var hsplit = SHOP_CONTAINER.get_child(i)
        hsplit.get_child(0).text = GameData.data["Upgrades"][i][0]
        hsplit.get_child(1).get_child(0).text = Utils.compress(GameData.data["Upgrades"][i][1])


func _process(delta):
    var followers = 0
    var bro_followers = 0
    for region in GameData.data["Regions"]:
        for category in GameData.data["Regions"][region]["Categories"]:
            followers += GameData.data["Regions"][region]["Categories"][category][0]
            bro_followers += GameData.data["Regions"][region]["Categories"][category][1]
    
    if bro_followers >= GameData.data["Upgrades"][-1][1]:
        get_tree().get_first_node_in_group("space").show_failure()
    
    SOCIABILITY_OPTION.selected = GameData.data["Edicts"][0]
    WORSHIP_OPTION.selected = GameData.data["Edicts"][1]
    FOLLOWERS_LABEL.text = Utils.compress(followers)
    TENT_LABEL.text = Utils.compress(bro_followers)
    SOULS_LABEL.text = Utils.compress(GameData.data["Souls"])
    STRESS_BAR.value = GameData.data["Stress"]
    var min_stress = 0.2
    var max_stress = 0.6
    var hue_frac = clamp(0, 1, (GameData.data["Stress"] - min_stress) / (max_stress - min_stress))
    STRESS_BAR.tint_progress = Color.from_hsv((1 - hue_frac) * 110.0 / 255, .5, .47)
    
    var unused_acolytes = 0
    for acolyte in GameData.data["Acolytes"]:
        if acolyte == "":
            unused_acolytes += 1
    UNUSED_ACOLYTES_LABEL.text = str(unused_acolytes)    
    
    for i in range(len(GameData.data["Upgrades"])):
        var hsplit = SHOP_CONTAINER.get_child(i)
        if not GameData.data["Upgrades"][i][3] and GameData.data["Upgrades"][i][1] < (GameData.data["Souls"] + followers) * 10:
            GameData.data["Upgrades"][i][3] = true
        hsplit.visible = GameData.data["Upgrades"][i][3] and not GameData.data["Upgrades"][i][2]
        hsplit.get_child(1).get_child(0).disabled = GameData.data["Upgrades"][i][1] > GameData.data["Souls"]


func _on_button_pressed(button_number):
    GameData.data["Souls"] -= GameData.data["Upgrades"][button_number][1]
    GameData.data["Upgrades"][button_number][2] = true
    if "Acolyte" in GameData.data["Upgrades"][button_number][0]:
        GameData.data["Acolytes"].append("")
        if len(GameData.data["Acolytes"]) == 1 and not GameData.data["ShownAcolyte"]:
            GameData.data["ShownAcolyte"] = true
            get_tree().get_first_node_in_group("tutorial").display(["You've acquired your first acolyte! Acolytes are rare followers powerful enough to think about you and stay alive. You can send them to a region to help out your followers, and you'll recieve boosts to all influence in that region."])
    elif "Planet" in GameData.data["Upgrades"][button_number][0]:
        get_tree().get_first_node_in_group("space").show_ending()
    elif "Shop" in GameData.data["Upgrades"][button_number][0]:
        for region in GameData.data["Regions"]:
            GameData.data["Regions"][region]["PriceScale"] *= 0.5
    elif "Spambots" in GameData.data["Upgrades"][button_number][0]:
        for region in GameData.data["Regions"]:
            for category in GameData.data["Regions"][region]["Categories"]:
                GameData.data["Regions"][region]["Categories"][category][3] *= 1.2
                if GameData.data["Upgrades"][button_number][0]:
                    GameData.data["Regions"][region]["Categories"][category][3] *= 1.2


func _on_option_button_item_selected(index):
    GameData.data["Edicts"][0] = SOCIABILITY_OPTION.selected
    GameData.data["Edicts"][1] = WORSHIP_OPTION.selected
