extends Node

'''
TODO
* disable scripts for previews
* change groups for previews
* revert the above changes when placed
'''

@export var stored : Dictionary = {
	"ore" = 0,
	"money" = 50
}

@export var unemployed_population : int = 10
@export var total_population : int = 10
@onready var ground_layer : TileMapLayer = $"../GroundLayer"

@export var buildingPrefabs : Array = [
	"res://Prefabs/drill.tscn",
	"res://Prefabs/city_center.tscn",
	"res://Prefabs/habitat.tscn",
	"res://Prefabs/launcher.tscn",
	"res://Prefabs/ship_depot.tscn"
]

@onready var previewInstanceParent : Node2D = $"../Cursor/PreviewParent"
const BUILDING_BUTTON = preload("res://Prefabs/UI/building_button.tscn")
var buildingBrush = null;

func assign_workers(amount : int) -> void:
	if (unemployed_population - amount > 0):
		unemployed_population -= amount

func _ready() -> void:
	ground_layer.global_position = Vector2.ZERO;
	var pos = Vector2.ONE
	var _snapped = ground_layer.map_to_local(ground_layer.local_to_map(pos))
	populatePreviews()
	populateBuildUI()
	
	$"../UI".visible = true
	$"../UI/VBoxContainer/FoldableContainer/VBoxContainer/Button".pressed.connect(resetBuildingBrush)
	$"../UI/VBoxContainer/FoldableContainer".folding_changed.connect(foldingResetBuildingBrush)
	updateBuildingBrush()
	updateUI()


func subtractCost(cost : Dictionary) -> bool: # returns success
	for key in cost.keys():
		if stored.keys().has(key):
			if stored[key] >= cost[key]:
				stored[key] -= cost[key]
			else:
				print("not enough ", key)
				return false
		else:
			print("unrecognized key ", key)
			return false
	return true;

func build(buildingName : String, pos : Vector2):
	#var buildingPrefab : PackedScene = load(buildingPrefabs[buildingName])
	var building :Building = previewInstanceParent.get_node(buildingName)
	if not subtractCost(building.buildCost):
		building.queue_free()
		return
	add_child(building)
	building.global_position = pos
	updateUI()

func populatePreviews() -> void:
	for b in buildingPrefabs:
		var prefab : PackedScene = load(b)
		var inst : Building = prefab.instantiate()
		previewInstanceParent.add_child(inst)

func populateBuildUI():
	var parent : VBoxContainer = $"../UI/VBoxContainer/FoldableContainer/VBoxContainer"
	for inst :Building in previewInstanceParent.get_children():
		var button : TextureButton = BUILDING_BUTTON.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		button.texture_normal = inst.get_texture()
		button.get_node("Name").text = inst.name
		button.get_node("Costs").text = inst.costString()
		var clicked = func():
			buildingBrushSelected(inst.name)
		button.pressed.connect(clicked)
		parent.add_child(button)
		
func buildingBrushSelected(name : String):
	print(name)
	buildingBrush = name
	updateBuildingBrush()

func resetBuildingBrush():
	buildingBrush = null
	updateBuildingBrush()

func foldingResetBuildingBrush(folded):
	resetBuildingBrush()

func updateBuildingBrush():
	for b : Building in previewInstanceParent.get_children():
		b.visible = b.name == buildingBrush

func updateUI():
	$"../UI/VBoxContainer/Stored".text = storedString()
	
func storedString() -> String:
	var s = ""
	for k in stored.keys():
		if stored[k] > 0:
			s+= str(stored[k]) + " " + str(k) + " "
	return s
