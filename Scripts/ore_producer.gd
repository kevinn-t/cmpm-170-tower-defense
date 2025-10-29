extends Node2D

@export var ore_stored: int = 0
@export var max_ore_stored: int = 10
@export var ore_per_second: int = 1

# observe 1s Timer signal
func _on_timer_timeout() -> void:
	if (ore_stored <= max_ore_stored):
		print("mined ore")
		ore_stored += ore_per_second
