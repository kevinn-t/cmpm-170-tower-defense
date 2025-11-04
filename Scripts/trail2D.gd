# https://github.com/Gabbinetto/Trail2D-addon/blob/master/addons/trail_2d/trail_2d.gd
# referenced, but edited
extends Line2D

@export var length : float = 10

@onready var parent : Node2D = get_parent()
var offset : Vector2 = Vector2.ZERO

func _ready() -> void:
	offset = position
	top_level = true

func _physics_process(_delta: float) -> void:
	global_position = Vector2.ZERO

	var point : Vector2 = parent.to_global(offset)
	
	add_point(to_local(point), 0)
	
	if get_point_count() > length:
		remove_point(get_point_count() - 1)
