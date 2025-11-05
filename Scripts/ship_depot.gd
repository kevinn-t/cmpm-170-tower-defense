class_name TransportShipDepot
extends Building

@export var workers : int = 1
@export var max_workers : int = 2


const SHIP = preload("res://Prefabs/ship.tscn")

@export var destination : Building

func _ready() -> void:
	onBuilt.connect(on_built)

func on_built():
	pass
	# create my ship
	var inst : TransportShip = SHIP.instantiate()
	$"../../Units".add_child(inst)
	inst.global_position = global_position
	inst.home = self

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
		
	if (stored["ore"] <= 0):
		return
	
	if my_container == null:
		make_container()
	else:
		var ore = 1
		stored["ore"] -= ore
		my_container.stored["ore"] += ore
