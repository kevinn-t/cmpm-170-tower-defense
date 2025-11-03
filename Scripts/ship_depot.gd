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

@export var destination : Building


func _ready() -> void:
	onBuilt.connect(on_built)

func on_built():
	pass
	# create my ship
	var inst : TransportShip = SHIP.instantiate()
	$"../../Units".add_child(inst)
	inst.global_position = global_position

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
		
	if (ore_stored <= 0):
		return
	
	if my_container == null:
		make_container()
	else:
		var ore = 1
		ore_stored -= ore
		my_container.ore_stored += ore
