class_name Building
extends StaticBody2D

@export var stored : Dictionary = {
	"ore" = 0
}
@export var capacity : int = 10

@onready var _gm = $"../../"

# nw = +x & se = -x
# ne = -y & sw = +y
func grid_pos()->Vector2:
	var pos = Vector2()
	pos.x = round(global_position.x/32 + global_position.y/16)
	pos.y = round(global_position.x/-32 + global_position.y/16)
	return pos

func get_neighbors()->Array[Building]:
	var neighbors : Array[Building] = []
	var cart_coords : Vector2 = grid_pos()
	var neighbor_coords : Array[Vector2] = [
		Vector2(cart_coords.x+1, cart_coords.y),
		Vector2(cart_coords.x, cart_coords.y-1),
		Vector2(cart_coords.x-1, cart_coords.y),
		Vector2(cart_coords.x, cart_coords.y+1),
	]
	for coord in neighbor_coords:
		if _gm.all_buildings.has(coord):
			neighbors.append(_gm.all_buildings[coord])
	return neighbors

func add_storages(a : Dictionary, b : Dictionary) -> Dictionary:
	var c : Dictionary = a.duplicate()
	for k in b.keys():
		if c.has(k):
			c[k] += b[k]
	return c

# moves b into my storage, returns b after done moving
func unload_storage_into(b : Dictionary) -> Dictionary:
	for k in b.keys():
		if stored.has(k):
			var room_left = capacity - stored[k]
			var moved = min(b[k], room_left)
			stored[k] += moved
			b[k] -= moved
		else:
			var moved = min(b[k], capacity)
			stored[k] = moved
			b[k] -= moved
	return b

@export var team : int = 0
@export var max_integrity : int = 100 
@export var integrity : float = 100 # hit points

signal onHit()
signal onRepaired()
signal onDestroyed()
@warning_ignore("unused_signal")
signal onBuilt()
signal onDelivery()# delivered : Dictionary

signal refreshUI()
	

const HEALTH_BAR = preload("res://Prefabs/UI/health_bar.tscn")
func make_hp_bar():
	var inst : HealthBar = HEALTH_BAR.instantiate()
	add_child(inst)
	onHit.connect(inst.refresh)
	onRepaired.connect(inst.refresh)
	refreshUI.connect(inst.refresh)
	inst.refresh()
	inst.global_position = global_position + Vector2.DOWN * 20

const STORAGE_UI = preload("res://Prefabs/UI/storage_ui.tscn")
func make_storage_ui():
	var inst : StorageUI = STORAGE_UI.instantiate()
	add_child(inst)
	onDelivery.connect(inst.refresh)
	refreshUI.connect(inst.refresh)
	inst.refresh()

func get_texture() -> Texture2D:
	return $Sprite2D.texture

func hit(attacker : Gun):
	integrity -= attacker.damage
	if integrity <= 0:
		onDestroyed.emit()
		call_deferred("queue_free")
	else:
		onHit.emit()

func _ready() -> void:
	onHit.connect(explosion)
	make_hp_bar()
	make_storage_ui()
	_gm.all_buildings[grid_pos()] = self
	#print("added " + str(self) + " at " + str(grid_pos()))

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


const CONTAINER = preload("res://Prefabs/container.tscn")
@export var my_container : MatContainer 

func recieve_delivery(container : MatContainer) -> void:
	container.get_parent().my_container = null
	container.reparent(self)
	my_container = container
	#var s = unload_then_destroy_container()
	#onDelivery.emit(s)
	unload_then_destroy_container()
	onDelivery.emit()
	
func hasContainer() -> bool:
	return my_container != null

func make_container() -> MatContainer:
	var inst : MatContainer = CONTAINER.instantiate()
	add_child(inst)
	inst.global_position = Vector2(global_position.x,global_position.y-6)
	my_container = inst
	return inst

func unload_then_destroy_container():
	#var s = my_container.stored
	var _extra = unload_storage_into(my_container.stored)
	destroy_container()
	#return s

func destroy_container() -> void:
	my_container.queue_free()
	my_container = null
