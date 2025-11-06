extends Building
class_name Turret

@export var damage_per_second : int = 10
@export var interval : float = 1

@onready var timer : Timer = $Timer
@onready var gm = $"../.."

func _process(_delta: float) -> void:
	timer.wait_time = interval

func _on_timer_timeout() -> void:
	for object in $"Damage Radius".get_overlapping_bodies():
		if object.is_in_group("enemy"):
			object.health -= damage_per_second

func _physics_process(_delta: float) -> void:
	fire_guns(tryGetTarget())
		

@onready var bulletParent = $"../../Bullets"
func _ready() -> void:
	super()
	for c in get_children():
		if c is Gun:
			c.bulletParent = bulletParent
	
func tryGetTarget() -> Node:
	for b in $DetectionArea.get_overlapping_bodies():
		if b.team != team:
			#print("TARGET", b.name)
			return b
	return null

func fire_guns(target : Node):
	for c in get_children():
		if c is Gun:
			c.target = target
			c.set_firing(target != null)
			#print(target != null)

const SOUND = preload("res://Prefabs/shoot_sound.tscn")
func fireSFX():
	var inst : AudioStreamPlayer2D = SOUND.instantiate()
	add_child(inst)
	inst.global_position = global_position
	inst.play()
