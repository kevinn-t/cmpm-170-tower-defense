extends Node2D

@export var ore_pull_speed: int = 1
@export var shipment_size: int = 5
@export var ore_stored: int = 0
@export var max_ore_stored: int = 10

@export var ship_away: bool = false
'''
TODO:
* put ore into ship
* pull ore from adjacent buildings
'''

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if (ore_stored >= shipment_size and not ship_away):
		print("shipped ore")
		ore_stored -= shipment_size
