extends Sprite2D

var buildCost : Dictionary = {}

func costString():
	return "Ore: " + str(buildCost["ore"]) + ", Money: " + str(buildCost["money"])

#func _ready() -> void:
	#var file = FileAccess.open("res://Data/info.json", FileAccess.READ)
	#var json_text = file.get_as_text()
	#file.close()
	#
	#var json = JSON.new()
	#var _error = json.parse(json_text)
#
	#var data = json.get_data()
	#var buildingInfo = data["buildings"]
	#print("[building_cost.gd] " + name)
	#cost["ore"] = buildingInfo[str(name)].cost.ore
	#cost["money"] = buildingInfo[str(name)].cost.money
	#
#func cost_string():
	#return "Ore: " + str(cost["ore"]) + ", Money: " + str(cost["money"])
