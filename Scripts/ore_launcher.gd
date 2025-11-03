extends Building

@export var money_per_ore : int = 1
@export var cooldown_time : float = 5
@export var workers : int = 0
@export var max_workers : int = 4

@onready var shipment_cooldown : Timer = $Timer

'''
increase velocity.y for every container in packages_in_loading
do it on a cooldown
after package reaches top bound of camera delete it and 
add money to game_manager.stored["money"]

top of camera = 
position of camera
+
get_visible_rect().size.y / 2
'''

func _ready() -> void:
	shipment_cooldown.wait_time = cooldown_time

func _physics_process(_delta: float) -> void:
	if (shipment_cooldown.time_left > 0 and workers > 0):
		var packages_in_loading : Array[StaticBody2D] = $"Package Check Area".get_overlapping_bodies()
		for package in packages_in_loading:
			package.position.move_toward(Vector2(position.x, 999), 50) # change y to top of camera 
		print("shipped ore")
		shipment_cooldown.start()
