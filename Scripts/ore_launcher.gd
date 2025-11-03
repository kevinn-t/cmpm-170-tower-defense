extends Building

@export var money_per_ore : int = 1
@export var cooldown_time : float = 5
@export var workers : int = 0
@export var max_workers : int = 4

@onready var shipment_cooldown : Timer = $Timer
@onready var gm : GameManager = $"../.."

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
		for child in get_children():
			if child.is_in_group("container"):
				var cam = $"../../Camera2D"
				child.position.move_toward(Vector2(global_position.x, cam.get_screen_center_position()+cam.get_viewport_rect().size.y), 50)
				shipment_cooldown.start()
				gm.stored["money"] += child.ore_stored * money_per_ore
				
