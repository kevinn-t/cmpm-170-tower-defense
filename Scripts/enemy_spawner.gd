extends Node2D

@onready var enemy = preload("res://Prefabs/enemy.tscn")



func _on_timer_timeout() -> void:
	var e = enemy.instantiate()
	e.position = position
	get_parent().add_child(e)
