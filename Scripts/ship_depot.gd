class_name TransportShipDepot
extends Building

@export var ore_stored : int = 0
@export var max_ore_stored : int = 10
@export var workers : int = 1
@export var max_workers : int = 2

const SHIP = preload("res://Prefabs/ship.tscn")

@export var destination : Building
var new_destination = CollisionObject2D
@onready var selecting : bool = false

func _ready() -> void:
	onBuilt.connect(on_built)
	$GUI.visible = false

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


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			# toggle entire thing
			$GUI.visible = !$GUI.visible
			# reset stuff
			new_destination = null
			selecting = false
			$"GUI/Control/Set Dest Button".text = "Set Destination"
			$GUI/Route.clear_points()
			$GUI/Route.add_point(to_local(destination.global_position))
			$GUI/Route.add_point(Vector2(0,0))


func _on_repair_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			selecting = !selecting
			$"GUI/Control/Set Dest Button".text = "Cancel" if selecting else "Set Destination"
			# set new destination
			if selecting and new_destination!=null:
				destination = new_destination
				new_destination = null
				
				$GUI/Route.clear_points()
				$GUI/Route.add_point(to_local(destination.global_position))
				$GUI/Route.add_point(Vector2(0,0))
				selecting = false
				$"GUI/Control/Set Dest Button".text = "Set Destination"


func _on_cursor_on_click(collider: CollisionObject2D) -> void:
	new_destination = collider
	
# open depot gui
# says set destination, selecting is false
# click on button -> says cancel
# click cancel / click on building / close gui -> set new_destination to null
