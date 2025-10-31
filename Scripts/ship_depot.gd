extends Building

@export var ore_stored : int = 1
@export var max_ore_stored : int = 10
@export var workers : int = 0
@export var max_workers : int = 2

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
		
	if (ore_stored <= 0):
		return
		
	var all_containers = get_tree().get_nodes_in_group("container")
	var has_container = false
	for _container in all_containers:
		if _container.global_position.distance_to(global_position) < 4: # actual range=17.89
			ore_stored -= 1
			_container.ore_stored += 1
			has_container = true
	
	if (!has_container):
		# need to get this working
		var container_prefab = load("res://Prefabs/container.tscn")
		var new_container = container_prefab.instantiate()
		add_child(new_container)
		new_container.global_position = Vector2(global_position.x,global_position.y-2)
