class_name Building
extends StaticBody2D

@export var buildCost : Dictionary = {
	"ore" : 3,
	"money" : 0
}
@export var integrity : int = 100 # hit points

signal onHit()
signal onDestroyed()
signal onBuilt()

func get_texture() -> Texture2D:
	return $Sprite2D.texture

func hit(attacker : CharacterBody2D):# not character, unit
	integrity -= attacker.damage
	if integrity <= 0:
		onDestroyed.emit()
		queue_free()
	else:
		onHit.emit()

func costString() -> String:
	#return str(buildCost)
	var s = ""
	for k in buildCost.keys():
		if buildCost[k] > 0:
			s+= str(buildCost[k]) + " " + str(k) + " "
	return s
