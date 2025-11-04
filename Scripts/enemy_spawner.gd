extends Node2D

@onready var enemy = preload("res://Prefabs/enemy.tscn")
@onready var enemies: Node2D = $"../Enemies"

func _ready() -> void:
	spawn_enemy()
	$Timer.stop() # temporary just spawn 1 and stop

func _on_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy():
	var e = enemy.instantiate()
	e.global_position = global_position
	enemies.add_child(e)
