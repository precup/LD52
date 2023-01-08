extends MarginContainer

@onready var TITLE_LABEL = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var SCORE_LABEL = $PanelContainer/MarginContainer/VBoxContainer/Label2
@onready var DIFF_LABEL = $PanelContainer/MarginContainer/VBoxContainer/Label3
@onready var SUBMIT_ROW = $PanelContainer/MarginContainer/VBoxContainer/HSplitContainer
@onready var NAME_TEXT = $PanelContainer/MarginContainer/VBoxContainer/HSplitContainer/HSplitContainer/MarginContainer/TextEdit
@onready var LEADERBOARD = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var MAIN_MENU = load("res://map.tscn")

var _score = 0

func display_leaderboard(score, eligible):
    visible = true
    _score = score
    var days_taken = score / 24.0 / 3600.0
    DIFF_LABEL.visible = not eligible
    SUBMIT_ROW.visible = eligible
    SCORE_LABEL.text = "You beat the game in %.1f days." % days_taken
    SCORE_LABEL.visible = score > 0
    TITLE_LABEL.text = "Congratulations" if score > 0 else "Leaderboard"
    $HTTPRequest.request("http://catpcha.net/")
    display_records([])


func display_records(records):
    if records == null:
        for i in range(LEADERBOARD.get_child_count()):
            var label = LEADERBOARD.get_child(i)
            label.visible = i == 0
            label.text = "Failed to load leaderboard."
        return
            
    for i in range(LEADERBOARD.get_child_count(), len(records)):
        var example_label = LEADERBOARD.get_child(0)
        var new_label = example_label.duplicate()
        LEADERBOARD.add_child(new_label)
        
    for i in range(LEADERBOARD.get_child_count()):
        var label = LEADERBOARD.get_child(i)
        label.visible = i < len(records)
        if i < len(records):
            label.text = "%d. %s: %.1f days" % [i + 1, records[i][0], records[i][1] / 24.0 / 3600.0]
    
    if len(records) == 0:
        var first_label = LEADERBOARD.get_child(0)
        first_label.visible = true
        first_label.text = "Loading leaderboard..."


func _on_button_pressed():
    sanitize_name()
    if _score > 0 and len(NAME_TEXT.text) > 0:
        $HTTPRequest.request("http://catpcha.net/%s/%d" % [NAME_TEXT.text.uri_encode(), _score])


func _on_http_request_request_completed(result, response_code, headers, body):
    var records = JSON.parse_string(body.get_string_from_utf8())
    display_records(records)


func _on_text_edit_text_changed():
    pass

func sanitize_name():
    var acceptable_text = ""
    for c in NAME_TEXT.text:
        if c.to_lower() in "abcdefghijklmnopqrstuvwxyz0123456789-_ ":
            acceptable_text += c
    NAME_TEXT.text = acceptable_text
    if len(NAME_TEXT.text) > 60:
        NAME_TEXT.text = NAME_TEXT.text.substr(0, 60)


func _on_menu_pressed():
    get_tree().change_scene_to_packed(MAIN_MENU)
