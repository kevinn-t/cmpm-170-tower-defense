extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$AudioStreamPlayer2D.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible = false

func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
