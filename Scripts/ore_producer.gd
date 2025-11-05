extends Building

@export var ore_per_second : int = 1
@export var check_radius : int = 18
var index : int = 0
@onready var gm = $"../.."

func _ready() -> void:
	onBuilt.connect(on_built)

func on_built()->void:
	gm.all_buildings[grid_pos()] = self

# TODO make it so that smoke emission rate is determined by whether or not ore has been generated,
# if inactive show inactive sprite, else show normal sprite

func _on_timer_timeout() -> void:
	#print(get_neighbors())
	
	## switch depot checking to use Depot Check Area
	#var nearby : Array[Node2D] = $"Depot Check Area".get_overlapping_bodies()
	var depots : Array[Building] = []
	
	for building : Building in get_neighbors():
		if building.is_in_group("ship_depot"):
			depots.append(building)
	
	if (index >= depots.size()):
		index = 0
	if (depots):
		if (depots[index].stored["ore"] < depots[index].capacity):
			stored["ore"] += 1
			stored = depots[index].unload_storage_into(stored)
	index += 1
	refreshUI.emit()
	
