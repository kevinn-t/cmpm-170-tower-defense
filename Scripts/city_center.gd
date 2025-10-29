extends Node2D

var game_manager : Node

func _ready() -> void:
	game_manager = get_node("%Game Manager")

func upgrade() -> void:
	game_manager.total_population += 5
	game_manager.unemployed_population += 5
