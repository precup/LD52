extends Control

@onready var SOCIABILITY_OPTION = $Sidebar/MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer3/HSplitContainer/OptionButton
@onready var WORSHIP_OPTION = $Sidebar/MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer4/HSplitContainer/OptionButton
@onready var TIME_LABEL = $TimeBar/HBoxContainer/MarginContainer/Label
@onready var TIME1_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer/PanelContainer
@onready var TIME2_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer2/PanelContainer
@onready var TIME4_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer3/PanelContainer

var base_tick_rate: float = 18000.0
var tick_rate_mod: int = 1

func set_tick_rate_mod(new_mod):
    tick_rate_mod = new_mod
    TIME1_HIGHLIGHT.visible = new_mod == 1
    TIME2_HIGHLIGHT.visible = new_mod == 2
    TIME4_HIGHLIGHT.visible = new_mod == 4


func update_time():
    var time : Dictionary = Time.get_datetime_dict_from_unix_time(int(GameData.data["Time"]));
    var display_string : String = "%d/%02d/%02d %02d:%02d" % [time["year"], time["month"], time["day"], time["hour"], 0];
    TIME_LABEL.text = display_string


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    advance_state(delta * base_tick_rate * tick_rate_mod)
    update_time()


func advance_state(ms):
    GameData.data["Time"] += ms


func _on_shop_button(region):
    pass # Replace with function body.


func _on_harvest(region, count):
    pass # Replace with function body.
