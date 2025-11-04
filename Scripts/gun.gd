extends Node2D
class_name Gun

@onready var shoot_cooldown: Timer = $ShootCooldown

var bulletParent : Node2D
var target : Node2D = null
var damage : int = 5

@export var bullet_speed = 500

const BULLET = preload("res://Prefabs/bullet.tscn")

func fire():
	if target == null or bulletParent == null:
		#print("null target or null parent")
		return
	var dir = (target.global_position - global_position).normalized()
	var inst : Bullet = BULLET.instantiate()
	bulletParent.add_child(inst)
	inst.gunParent = self
	inst.velocity = dir * bullet_speed
	rotation = atan2(dir.y, dir.x)
	inst.rotation = atan2(dir.y, dir.x)

func _on_shoot_cooldown_timeout() -> void:
	fire()
