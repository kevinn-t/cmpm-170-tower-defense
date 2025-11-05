class_name Unit
extends CharacterBody2D

@export var team : int = 0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
# set move speed on the nav agent

@export var home : Building

@export var my_container : MatContainer 
func load_container(container : MatContainer):
	container.get_parent().my_container = null
	container.reparent(self)
	my_container = container


@export var max_integrity : int = 100 
@export var integrity : int = 100 # hit points

signal onHit()
signal onDestroyed()

func get_texture() -> Texture2D:
	return $Sprite2D.texture

func hit(attacker : Gun):
	integrity -= attacker.damage
	if integrity <= 0:
		onDestroyed.emit()
		queue_free()
	else:
		onHit.emit()

func _ready() -> void:
	onHit.connect(explosion)
	make_hp_bar()

func _physics_process(_delta: float) -> void:
	health_bar.rotation = rotation * -1

const HEALTH_BAR = preload("res://Prefabs/UI/health_bar.tscn")
var health_bar : HealthBar
func make_hp_bar():
	health_bar = HEALTH_BAR.instantiate()
	add_child(health_bar)
	onHit.connect(health_bar.refresh)
	health_bar.refresh()
	health_bar.rotation = rotation * -1

const EXPLOSION = preload("res://Prefabs/explosion.tscn")
func explosion(explosion_iterations : int = 2, explosion_chance : float = 0.2, explosion_radius : float = 20):
	for i in range(explosion_iterations):
		var r = randf()
		if r > explosion_chance:
			return
		var inst : Node2D = EXPLOSION.instantiate()
		add_sibling(inst)
		
		var randCircle = Vector2(randfn(0.0,1.0),randfn(0.0,1.0)).normalized()
		if randCircle.length()>1:
			randCircle.normalized()
			
		inst.global_position = global_position + randCircle * explosion_radius
