extends Sprite2D

var buildCost : Dictionary = {}

func costString():
	return "Ore: " + str(buildCost["ore"]) + ", Money: " + str(buildCost["money"])
