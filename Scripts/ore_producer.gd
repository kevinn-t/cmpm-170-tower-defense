extends Node2D

@export var ore_stored: int = 0
@export var max_ore_stored: int = 10
@export var ore_per_second: int = 1
@export var workers: int = 0
@export var max_workers: int = 3

# observe 1s Timer signal
func _on_timer_timeout() -> void:
	if (ore_stored <= max_ore_stored):
		print("mined ore")
		ore_stored += workers # PLACEHOLDER make this scale by percentage at some point
