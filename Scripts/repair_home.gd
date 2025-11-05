extends Building

const SHIP = preload("res://Prefabs/repair_ship.tscn")

@export var my_ship : RepairShip
@onready var gm = $"../.."

func _ready() -> void:
	onBuilt.connect(on_built)

func on_built():
	my_ship = SHIP.instantiate()
	$"../../Units".add_child(my_ship)
	my_ship.global_position = global_position
	my_ship.home = self
	gm.all_buildings[grid_pos()] = self

func _process(_delta: float) -> void:
	if my_ship != null:
		my_ship.target = findTarget()
	
func findTarget():
	for b in $RepairDispatch.get_overlapping_bodies():
		if b is Building:
			if b.integrity < b.max_integrity:
				return b
	return null
