extends Building

@export var money_per_ore : int = 1
@export var cooldown_time : float = 5
@export var workers : int = 1
@export var max_workers : int = 4

@onready var shipment_cooldown : Timer = $Timer
@onready var gm : GameManager = $"../.."

func _process(_delta:float) -> void:
	shipment_cooldown.wait_time = cooldown_time

func _on_delivery(ore: Variant) -> void:
	if (workers > 0):
		gm.stored["money"] += ore * money_per_ore
