class_name TransportShipDepot
extends Building

'''
for some reason this is only working when childed under PreviewParent
cuz inside of Buildings, this keeps spawning new containers even though
theres already one

my goal for this is to push ore into a container if detected
if not, make a container

BUT if you Play, go to Scene->Remote->GameManager->Buildings->Ship Depot
you'll see a ton of @StaticBody's being made

BUT you don't see it happening to the Ship Depot under PreviewParent
'''

@export var ore_stored : int = 1
@export var max_ore_stored : int = 10
@export var workers : int = 1
@export var max_workers : int = 2


const SHIP = preload("res://Prefabs/ship.tscn")
const CONTAINER = preload("res://Prefabs/container.tscn")

@onready var gm : GameManager = find_parent("GameManager")

func _ready() -> void:
	onBuilt.connect(on_built)

func on_built():
	pass
	# create my ship
	var inst : TransportShip = SHIP.instantiate()
	gm.unitParent.add_child(inst)
	inst.global_position = global_position

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
		
	if (ore_stored <= 0):
		return
	
	var package_check : Array[Node2D]  = $"Package Check Area".get_overlapping_bodies()
	var containers : Array[StaticBody2D] = []
	
	for object in package_check:
		if object.is_in_group("container"):
			containers.append(object)
			
	print(containers.size())
	
	if containers.size() > 1:
		print("too many containers in loading zone")
		return
	if containers.size() == 1:
		if containers[0].ore_stored < containers[0].max_ore:
			ore_stored -= 1
			containers[0].ore_stored += 1
		return
	if containers.size() == 0:
		var inst : StaticBody2D = CONTAINER.instantiate()
		add_child(inst)
		inst.global_position = Vector2(global_position.x,global_position.y-6)
		return
