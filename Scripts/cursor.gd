extends Node2D

@onready var ground = $"../GroundLayer"
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var tile_position = ground.local_to_map(get_global_mouse_position())
	global_position = ground.map_to_local(tile_position)
