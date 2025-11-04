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

# TODO make it so that smoke emission rate is determined by whether or not ore has been generated

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
	
	# switch depot checking to use Depot Check Area
	var nearby : Array[Node2D] = $"Depot Check Area".get_overlapping_bodies()
	var depots : Array[StaticBody2D] = []
	
	for building in nearby:
		if building.is_in_group("ship_depot"):
			depots.append(building)

	if (index >= depots.size()):
		index = 0
	if (depots):
		if (depots[index].ore_stored < depots[index].max_ore_stored):
			depots[index].ore_stored += ore_per_second
	index += 1
	
