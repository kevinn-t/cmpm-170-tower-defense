extends Building

@export var money_per_ore : int = 1
@export var workers : int = 1
@export var max_workers : int = 4

@onready var shipment_cooldown : Timer = $Timer
@onready var gm : GameManager = $"../.."

func _on_delivery(delivered : Dictionary) -> void:
	stored = add_storages(stored, delivered)
	try_launch()
		
func try_launch():
	if shipment_cooldown.is_stopped():
		launch()
	else:
		shipment_cooldown.start()

func launch():
	$launchAnimation.visible = true
	$launchAnimation.play("launch")
	gm.stored["money"] += stored["ore"] * money_per_ore
	stored["ore"] = 0

func _on_launch_animation_animation_finished() -> void:
	visible = false

func _on_timer_timeout() -> void:
	launch()
