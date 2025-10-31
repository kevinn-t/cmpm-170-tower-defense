extends Building

@export var ore_per_second : int = 1
@export var workers : int = 1
@export var max_workers : int = 3
@export var check_radius : int = 18
var index : int = 0

'''
fill nearby depots 
* every second
* one by one
* round robin
'''

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
	
	var depots : Array[Node] = get_tree().get_nodes_in_group("ship_depot")
	var nearby : Array[Node] = []
	for depot in depots:
		# maybe range is too short? for some reason this is detecting the preview
		if depot.global_position.distance_to(global_position) < check_radius: # actual range=17.89
			nearby.append(depot)
	if (nearby):
		if (nearby[index].ore_stored < nearby[index].max_ore_stored):
			nearby[index].ore_stored += ore_per_second
		
	index += 1
	if (index >= nearby.size()):
		index = 0
