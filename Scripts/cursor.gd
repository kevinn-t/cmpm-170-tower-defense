extends Node2D

@onready var ground = $"../GroundLayer"
@onready var gm : GameManager = $".."

@export_flags_2d_physics var building_mask = 1

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var tile_position = ground.local_to_map(get_global_mouse_position())
	global_position = ground.map_to_local(tile_position)

var selected_building : CollisionObject2D
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var query = PhysicsPointQueryParameters2D.new()
			query.position = global_position
			query.collision_mask = 1
			
			var physics_space = get_world_2d().direct_space_state
			var results = physics_space.intersect_point(query)
			
			if (results.size() > 0):
				print("clicked on" + str(results[0].collider))
				selected_building = results[0].collider
				onClick.emit(results[0].collider)
	
signal onClick(collider : CollisionObject2D)
