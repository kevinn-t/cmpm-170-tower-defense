extends Building

@export var money_per_ore : int = 1
@export var cooldown_time : float = 5
@export var workers : int = 0
@export var max_workers : int = 4

var city_center : Node2D
@onready var shipment_cooldown : Timer = $Timer

func _ready() -> void:
	city_center = get_node("%City Center")
	shipment_cooldown.wait_time = cooldown_time

func _process(_delta : float) -> void:
	if (shipment_cooldown.time_left > 0 and workers > 0):
		# at some point lower the cooldown_time when there are multiple workers
		# TODO LEFT OFF HERE DO THIS
		# find out how to detect collisions
		# increase velocity.y for colliding Container
		# make this shoot ONE colliding package upward at a time
		print("shipped ore")
		shipment_cooldown.start()
		
