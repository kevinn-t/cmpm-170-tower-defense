extends Node2D

@export var ore_stored: int = 0
@export var shipment_size: int = 50
@export var money_per_ore: int = 1
@export var money_stored: int = 0

@onready var shipment_cooldown : Timer = $Timer

func _process(_delta : float) -> void:
	if (ore_stored >= shipment_size and shipment_cooldown.time_left > 0):
		print("shipped ore")
		ore_stored -= shipment_size
		money_stored += money_per_ore
		shipment_cooldown.start()
