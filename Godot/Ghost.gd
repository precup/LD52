extends Node2D

var lifespan = 1.0
var LIFESPAN_RANGE = [2.0, 4.0]
var SPEED = 40.0

func _ready():
    lifespan = randf_range(LIFESPAN_RANGE[0], LIFESPAN_RANGE[1])
    $sprite.frame = randi_range(0, $sprite.frames.get_frame_count("default") - 1)

func _process(delta):
    $sprite.modulate = Color(1.0, 1.0, 1.0, min(1.0, lifespan / LIFESPAN_RANGE[0])) 
    position.y -= delta * SPEED
    lifespan -= delta
    if lifespan < 0:
        queue_free()
