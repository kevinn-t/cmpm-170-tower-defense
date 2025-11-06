class_name GameManager
extends Node2D
# goes on the root of the main scene

# formatted "0,0" : StaticBody2D
@export var all_buildings : Dictionary = {}

@export var stored : Dictionary :
	get:
		return $"Buildings/City Center".stored
	set(value):
		$"Buildings/City Center".stored = value
		$"Buildings/City Center".refreshUI.emit()

@onready var ground_layer: TileMapLayer = $GroundLayer

const json_file_path = "res://Data/info.json"

# loaded from json
var buildingInfo : Dictionary
var unitInfo : Dictionary

func _ready() -> void:
	ground_layer.global_position = Vector2.ZERO;
	var pos = Vector2.ONE
	var _snapped = ground_layer.map_to_local(ground_layer.local_to_map(pos))
	
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var _error = json.parse(json_text)

	var data = json.get_data()
	#print(_error)
	buildingInfo = data["buildings"]
	unitInfo = data["units"]
	stored = data["starting_stored"]

func _process(_delta: float) -> void:
	$UI/VBoxContainer/Stored.text = "money: " + str(stored.money) + "\nOre: " + str(stored.ore)


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
