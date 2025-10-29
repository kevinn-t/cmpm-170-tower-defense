extends Node2D

@export var ore_stored: int = 0
@export var shipment_size: int = 50
@export var money_per_ore: int = 1
@export var cooldown_time: float = 5
@export var workers: int = 0
@export var max_workers: int = 4

var city_center : Node2D

@onready var shipment_cooldown : Timer = $Timer

func _ready() -> void:
	city_center = get_node("%City Center")
	shipment_cooldown.wait_time = cooldown_time

func _process(_delta : float) -> void:
	if (ore_stored >= shipment_size and shipment_cooldown.time_left > 0 and workers > 0):
		print("shipped ore")
		ore_stored -= shipment_size
		city_center.money += money_per_ore * shipment_size
		shipment_cooldown.start()
		# make this trigger only when the # of workers change
		# cooldown_time -= workers * 0.5
