extends Building

@export var damage_per_second : int = 10
@export var interval : float = 1

@onready var timer : Timer = $Timer

func _process(_delta: float) -> void:
	timer.wait_time = interval

func _on_timer_timeout() -> void:
	for object in $"Damage Radius".get_overlapping_bodies():
		if object.is_in_group("enemy"):
			object.health -= damage_per_second
