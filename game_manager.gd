extends Node

@export var money : int = 100
@export var unemployed_population : int = 10
@export var total_population : int = 10
@onready var ground_layer : TileMapLayer = $"../GroundLayer"

func assign_workers(amount : int) -> void:
	if (unemployed_population - amount > 0):
		unemployed_population -= amount

func _ready() -> void:
	ground_layer.global_position = Vector2.ZERO;
	var pos = Vector2.ONE
	var _snapped = ground_layer.map_to_local(ground_layer.local_to_map(pos))
