extends Building

@export var ore_per_second: int = 1
@export var workers: int = 0
@export var max_workers: int = 3
@onready var collision : CollisionPolygon2D = $CollisionPolygon2D

var neighboring_depots = []

func _process(_delta:float) -> void:
	neighboring_depots = get_tree().get_nodes_in_group("ship_depot")

func _on_timer_timeout() -> void:
	#var depots = get_tree().get_nodes_in_group("ship_depot")
	#for depot in depots:
		#if depot.global_position.position_to(global_position) < 18: # actual range=17.89
			#depot.ore_stored += 1
	pass
	
