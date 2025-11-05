extends Node2D

@export var speed = 500

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position += Vector2.UP * speed * delta

func _on_lifetime_timeout() -> void:
	queue_free()
