extends PanelContainer

@onready var FLAVOR_LABEL = $PopUp/PanelContainer/MarginContainer/HBoxContainer/Label2
@onready var EFFECT_LABEL = $PopUp/PanelContainer/MarginContainer/HBoxContainer/Label3

var display_time = 0
var delay = 1000

func display(flavor, effect):
    get_tree().paused = true
    visible = true
    display_time = Time.get_ticks_msec()
    FLAVOR_LABEL.text = flavor
    EFFECT_LABEL.text = "[i]" + effect


func _input(event):
    if visible and not get_tree().get_first_node_in_group("space").visible and not get_tree().get_first_node_in_group("tutorial").visible and Input.is_action_just_pressed("continue") and display_time + delay < Time.get_ticks_msec():
        SceneTree.paused = false
        visible = false
