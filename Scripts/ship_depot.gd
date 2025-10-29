extends Node2D

# how much ore/sec this would pull from adjacent ore producers
@export var ore_pull_speed: int 

@export var shipment_size: int = 5
@export var ore_stored: int = 0
@export var max_ore_stored: int = 10
@export var workers: int = 0
@export var max_workers: int = 2
@export var ship_away: bool = false
'''
TODO:
* put ore into ship
* pull ore from adjacent buildings
'''

func _process(_delta: float) -> void:
	ore_pull_speed = workers # PLACEHOLDER make this scale by pecentage at some point
	
	if (ore_stored >= shipment_size and not ship_away and workers > 0):
		print("shipped ore")
		ore_stored -= shipment_size
