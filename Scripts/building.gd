class_name Building
extends StaticBody2D

@export var max_integrity : int = 100 
@export var integrity : int = 100 # hit points

signal onHit()
signal onDestroyed()
@warning_ignore("unused_signal")
signal onBuilt()
signal onDelivery(ore)

const HEALTH_BAR = preload("res://Prefabs/UI/health_bar.tscn")
func make_hp_bar():
	var inst : HealthBar = HEALTH_BAR.instantiate()
	add_child(inst)
	onHit.connect(inst.refresh)
	inst.refresh()
	

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

const EXPLOSION = preload("res://Prefabs/explosion.tscn")
func explosion(explosion_iterations : int = 2, explosion_radius : float = 20):
	for i in range(explosion_iterations):
		var inst : Node2D = EXPLOSION.instantiate()
		add_sibling(inst)
		
		var randCircle = Vector2(randfn(0.0,1.0),randfn(0.0,1.0)).normalized()
		if randCircle.length()>1:
			randCircle.normalized()
			
		inst.global_position = global_position + randCircle * explosion_radius


const CONTAINER = preload("res://Prefabs/container.tscn")
@export var my_container : MatContainer 

func recieve_delivery(container : MatContainer) -> void:
	container.get_parent().my_container = null
	container.reparent(self)
	my_container = container
	var ore = unload_then_destroy_container()
	onDelivery.emit(ore)
	
func hasContainer() -> bool:
	return my_container != null

func make_container() -> MatContainer:
	var inst : MatContainer = CONTAINER.instantiate()
	add_child(inst)
	inst.global_position = Vector2(global_position.x,global_position.y-6)
	my_container = inst
	return inst

func unload_then_destroy_container() -> int:
	var ore = my_container.ore_stored
	destroy_container()
	return ore

func destroy_container() -> void:
	my_container.queue_free()
	my_container = null
