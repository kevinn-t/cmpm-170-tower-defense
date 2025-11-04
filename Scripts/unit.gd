class_name Unit
extends CharacterBody2D

@onready var nav: NavigationAgent2D = $NavigationAgent2D
# set move speed on the nav agent

@export var home : TransportShipDepot

@export var my_container : MatContainer 
func load_container(container : MatContainer):
	container.get_parent().my_container = null
	container.reparent(self)
	my_container = container


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

const EXPLOSION = preload("res://Prefabs/explosion.tscn")
func explosion(explosion_iterations : int = 5, explosion_radius : float = 0):
	for i in range(explosion_iterations):
		var inst : Node2D = EXPLOSION.instantiate()
		add_sibling(inst)
		
		var randCircle = Vector2(randfn(0.0,1.0),randfn(0.0,1.0)).normalized()
		if randCircle.length()>1:
			randCircle.normalized()
			
		inst.global_position = global_position + randCircle * explosion_radius
