extends PanelContainer

@onready var FLAVOR_LABEL = $PopUp/PanelContainer/MarginContainer/HBoxContainer/Label2

var display_time = 0
var delay = 500
var lines = [""]


func display(stuff):
    lines = stuff
    get_tree().paused = true
    visible = true
    _display(lines[0])


func _display(line):
    display_time = Time.get_ticks_msec()
    FLAVOR_LABEL.text = line


func _input(event):
    if visible and not get_tree().get_first_node_in_group("space").visible and Input.is_action_just_pressed("continue") and display_time + delay < Time.get_ticks_msec():
        lines.pop_front()
        if len(lines) == 0:
            get_tree().paused = false
            visible = false
        else:
            _display(lines[0])
