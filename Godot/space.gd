extends Control

@onready var LABEL = $PanelContainer/MarginContainer/Label
@onready var BROTHER = $sprites/yall/brothera
@onready var PLAYER = $sprites/AnimationPlayer

var tut_text = [
    "You've got one follower, ready to spread the bad word. The more faithful you have, especially on social media, the faster your influence will spread. 

You'll need 3 billion souls to teleport the planet, and you'll need to do it before your brother does. ",
"You can adjust your edicts to your faithful, but if you demand too much from your followers, they may die from thinking about you too much. 

You can harvest the souls of your followers at any time, although that will also cause them to die, which makes it difficult for them to post on social media. "
]

var state = 7 if GameData.is_debug else 0

var display_time = 0
var delay = 500
var lines = [""]


func show_ending():
    get_tree().paused = true
    visible = true
    advance_state()


func _ready():
    get_tree().paused = true
    visible = true
    advance_state()


func _input(event):
    if visible and Input.is_action_just_pressed("continue") and display_time + delay < Time.get_ticks_msec():
        advance_state()


func advance_state():
    display_time = Time.get_ticks_msec()
    state += 1
    match(state):
        1:
            LABEL.text = "You are a writhing mass of eyes and flesh, a cosmological horror so far beyond the realm of human comprehension that they might think you're a planet."
        2:
            LABEL.text = "The mere knowledge of your existence corrupts the minds of mortals, and dwelling on you alone can break their minds."
        3:
            LABEL.text = "Oh, and you've got a brother."
            PLAYER.play("slide")
            delay = 2000
        4:
            delay = 500
            LABEL.text = "He's basically just a ball of tentacles. Way less cool than eyes, frankly."
        5:
            LABEL.text = "One eon, while floating through the cosmic void, your brother noticed a planet full of life for the harvest..."
        6:
            BROTHER.frame = 1
        7:
            LABEL.text = "Thankfully, you don't respect dibs."
            BROTHER.frame = 0
        8:
            visible = false
            get_tree().get_first_node_in_group("tutorial").display(tut_text)
        9:
            LABEL.text = "Ah, finally. Enough souls to teleport the whole of the planet into your extradimensional maw."
        10:
            LABEL.text = "You look at your brother."
        11:
            BROTHER.frame = 2
        12:
            LABEL.text = ""
            BROTHER.frame = 0
        13:
            LABEL.text = "You eat his planet."
        14:
            LABEL.text = ""
            BROTHER.frame = 3
        15:
            BROTHER.frame = 4
        16:
            BROTHER.frame = 5
        17:
            LABEL.text = "Thanks for playing! -Arch"
