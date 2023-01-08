extends Control

@onready var MAP_SCENE: PackedScene = load("res://map.tscn")

func _ready():
    visible = true
    get_tree().paused = true
    $VBoxContainer/Button2.visible = GameData.has_autosave()
    if GameData.is_debug:
        start_new_game(GameData.NORMAL_DIFFICULTY)


func _on_button_pressed():
    $VBoxContainer.visible = false
    $VBoxContainer2.visible = true


func _on_button_2_pressed():
    GameData.load_autosave()
    get_tree().get_first_node_in_group("space").state = 8
    visible = false
    get_tree().paused = false


func start_new_game(difficulty):
    GameData.reset()
    GameData.data["Difficulty"] = difficulty
    visible = false
    get_tree().get_first_node_in_group("space").show_start()


func _on_unloseable_pressed():
    start_new_game(GameData.UNLOSEABLE_DIFFICULTY)


func _on_normal_pressed():
    start_new_game(GameData.NORMAL_DIFFICULTY)


func _on_easy_pressed():
    start_new_game(GameData.UNLOSEABLE_DIFFICULTY)


func _on_button_3_pressed():
    get_tree().get_first_node_in_group("leaderboard").display_leaderboard(-1, false)
