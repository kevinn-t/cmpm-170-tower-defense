class_name Building
extends StaticBody2D

@export var buildCost : Dictionary = {
	"ore" : 3,
	"money" : 0
}
@export var integrity : int = 100 # hit points

signal onHit()
signal onDestroyed()

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
	return str(buildCost)
