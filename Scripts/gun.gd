extends Node2D
class_name Gun

@onready var shoot_cooldown: Timer = $ShootCooldown

var bulletParent : Node2D
var target : Node2D = null
@export var damage : int = 5
@export var bullet_speed = 500

const BULLET = preload("res://Prefabs/bullet.tscn")

func set_firing(firing : bool = true):
	if firing:
		if shoot_cooldown.is_stopped():
			shoot_cooldown.start()
	else:
		shoot_cooldown.stop()
		

func fire():
	if target == null:
		#print("null target or null parent")
		return
	if bulletParent == null:
		print("SET THE BULLET PARENT IN ", get_parent())
		return
	#print("Gun fired at ", target)
	var dir = (target.global_position - global_position).normalized()
	var inst : Bullet = BULLET.instantiate()
	inst.add_collision_exception_with(get_parent())
	bulletParent.add_child(inst)
	inst.gunParent = self
	inst.global_position = global_position
	inst.linear_velocity = dir * bullet_speed
	rotation = atan2(dir.y, dir.x)
	inst.rotation = atan2(dir.y, dir.x)

func _on_shoot_cooldown_timeout() -> void:
	fire()
