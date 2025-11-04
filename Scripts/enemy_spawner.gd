extends Node2D

@onready var enemy = preload("res://Prefabs/enemy.tscn")
@onready var enemies: Node2D = $"../Enemies"

func _on_timer_timeout() -> void:
	var e = enemy.instantiate()
	e.global_position = global_position
	enemies.add_child(e)
