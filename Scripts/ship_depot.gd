class_name TransportShipDepot
extends Building

@export var workers : int = 1
@export var max_workers : int = 2

const SHIP = preload("res://Prefabs/ship.tscn")

@export var destination : Building
@onready var selecting : bool = false

func _ready() -> void:
	onBuilt.connect(on_built)
	$GUI.visible = false
	$"../../Cursor".onClick.connect(on_any_click)

func on_built():
	pass
	# create my ship
	var inst : TransportShip = SHIP.instantiate()
	$"../../Units".add_child(inst)
	inst.global_position = global_position
	inst.home = self

func _on_timer_timeout() -> void:
	if (workers <= 0):
		return
		
	if (stored["ore"] <= 0):
		return
	
	if my_container == null:
		make_container()
	else:
		var ore = 1
		stored["ore"] -= ore
		my_container.stored["ore"] += ore


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			# toggle entire thing
			$GUI.visible = !$GUI.visible
			# reset stuff
			refresh_gui()


func _on_repair_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			selecting = !selecting
			$"GUI/Control/Set Dest Button".text = "Cancel" if selecting else "Set Destination"
			
			refresh_gui()
				
func on_any_click(new_destination):
	print(selecting)
	if selecting:
		if new_destination != null:
			destination = new_destination
			selecting = false
	refresh_gui()
	
func refresh_gui():
	$"GUI/Control/Set Dest Button".text = "Cancel" if selecting else "Set Destination"
	$GUI/Route.clear_points()
	$GUI/Route.add_point(to_local(destination.global_position))
	$GUI/Route.add_point(Vector2(0,0))

#func _on_cursor_on_click(collider: CollisionObject2D) -> void:
	#new_destination = collider
