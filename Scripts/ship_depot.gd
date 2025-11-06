class_name TransportShipDepot
extends Building

@onready var gm = $"../.."

const SHIP = preload("res://Prefabs/ship.tscn")
var my_ship : TransportShip

@export var destination : Building
@onready var selecting : bool = false

func _ready() -> void:
	onBuilt.connect(on_built)
	$GUI.visible = false
	$"../../Cursor".onClick.connect(on_any_click)

func on_built():
	pass
	# create my ship
	my_ship = SHIP.instantiate()
	$"../../Units".add_child(my_ship)
	my_ship.global_position = global_position
	my_ship.home = self
	gm.all_buildings[grid_pos()] = self
	#$GUI.visible = true
	#selecting = true

func _on_timer_timeout() -> void:
	if (stored["ore"] <= 0):
		return
	
	if my_container == null:
		make_container()
	else:
		if my_container.stored["ore"] < capacity:
			var ore = 1
			stored["ore"] -= ore
			my_container.stored["ore"] += ore
		
# click on depot itself
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
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
			refresh_gui()
				
func on_any_click(new_destination):
	if selecting:
		if new_destination != null:
			destination = new_destination
			#my_ship.nav.target_position = destination.global_position
			selecting = false
			$GUI.visible = false
	refresh_gui()
	
func refresh_gui():
	if $GUI.visible:
		$"GUI/Control/Set Dest Button".text = "Cancel" if selecting else "Set Destination"
		if destination == null:
			return
		$GUI/Route.clear_points()
		$GUI/Route.add_point(to_local(destination.global_position))
		$GUI/Route.add_point(Vector2(0,0))
