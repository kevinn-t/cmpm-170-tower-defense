class_name Builder
extends Node2D

@onready var ground = $"../GroundLayer"
@onready var gm : GameManager = $".."
@onready var cursor: Node2D = $"../Cursor"

# null or string name of the building in the array
var brush = null

@onready var previewInstanceParent : Node2D = $"../Cursor/PreviewParent"
const BUILDING_BUTTON = preload("res://Prefabs/UI/building_button.tscn")
@onready var unitParent : Node2D = $"../Units"
@onready var buildingsParent : Node2D = $"../Buildings"
@onready var buildingUIButtonParent : VBoxContainer = $"../UI/VBoxContainer/FoldableContainer/VBoxContainer"

@export var clearBrushAfterBuild : bool = true

var previews : Array[NodePath] = [
	"../Cursor/PreviewParent/drill",
	"../Cursor/PreviewParent/turret",
	"../Cursor/PreviewParent/launcher",
	"../Cursor/PreviewParent/transport depot",
	"../Cursor/PreviewParent/repair depot"
]
var buttons : Array[NodePath] = [
	"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Drill",
	"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Turret",
	"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Launcher",
	"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Transport",
	"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Repair"
]

func _ready() -> void:
	await gm.ready
	populatePreviews()
	populateBuildUI()
	
	$"../UI".visible = true
	$"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Button".pressed.connect(resetBuildingBrush)
	$"../UI/VBoxContainer/FoldableContainer".folding_changed.connect(foldingResetBuildingBrush)
	updateBuildingBrush()
	updateUI()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				if (brush):
					build(brush, $"../Cursor".global_position)


func build(buildingName : String, pos : Vector2):
	if not gm.subtractCost(previewInstanceParent.get_node(buildingName).buildCost):
		return
	var buildingInfo = gm.buildingInfo[buildingName]
	var buildingPrefab : PackedScene = load(buildingInfo.prefab)
	var building :Building = buildingPrefab.instantiate()
	
	buildingsParent.add_child(building)
	building.global_position = pos
	
	#await  building.ready
	building.onBuilt.emit()
	updateUI()
	#print("built ", building, " ", building.global_position)
	if clearBrushAfterBuild:
		resetBuildingBrush()

func populatePreviews() -> void:
	#for b in gm.buildingInfo:
		#var prefab : PackedScene = load(gm.buildingInfo[b].sprite)
		#var inst : Sprite2D = prefab.instantiate()
		#inst.name = gm.buildingInfo[b].name
		#inst.buildCost["ore"] = gm.buildingInfo[b].cost.ore
		#inst.buildCost["money"] = gm.buildingInfo[b].cost.money
		#previewInstanceParent.add_child(inst)
	#print(gm.buildingInfo)
	#for i in range(len(previews)):
		#var inst = get_node(previews[i])
		#inst.buildCost["ore"] = gm.buildingInfo[inst.name].cost.ore
		#inst.buildCost["money"] = gm.buildingInfo[inst.name].cost.money
		#previewInstanceParent.add_child(inst)
	pass

func populateBuildUI():
	#for inst : Sprite2D in previewInstanceParent.get_children():
		#var button : TextureButton = BUILDING_BUTTON.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		#button.texture_normal = inst.get_texture()
		#button.get_node("Name").text = inst.name
		#button.get_node("Costs").text = inst.costString()
		#var clicked = func():
			#buildingBrushSelected(inst.name)
		#button.pressed.connect(clicked)
		#buildingUIButtonParent.add_child(button)
	for i in range(len(previews)):
		var inst = get_node(previews[i])
		var button : Button = get_node(buttons[i])
		#print("BUTT: ", button, " INST: ", inst, " PATHS ", previews[i]," &&& ", buttons[i])
		button.get_node("TextureRect").texture = inst.get_texture()
		button.get_node("Name").text = inst.name
		button.get_node("Costs").text = costString(gm.buildingInfo[inst.name].cost)
		var clicked = func():
			buildingBrushSelected(inst.name)
		button.pressed.connect(clicked)
		
func buildingBrushSelected(brush_name : String):
	brush = brush_name
	updateBuildingBrush()

func resetBuildingBrush():
	brush = null
	updateBuildingBrush()

func foldingResetBuildingBrush(_folded):
	resetBuildingBrush()

func updateBuildingBrush():
	for b : Sprite2D in previewInstanceParent.get_children():
		b.visible = b.name == brush

func updateUI():
	$"../UI/VBoxContainer/Stored".text = storedString()
	
func storedString() -> String:
	var s = ""
	for k in gm.stored.keys():
		if gm.stored[k] > 0:
			s+= str(gm.stored[k]) + " " + str(k) + " "
	return s

func costString(cost : Dictionary) -> String:
	var s = ""
	for k in cost.keys():
		if cost[k] > 0:
			s+= str(cost[k]) + " " + str(k) + " "
	return s
