class_name MatContainer
extends StaticBody2D

# needs to start with 1 because depots check for an existing containter & +1 ot it
# BEFORE it has the chance to spawn one so when it does, it would normally be empty
# but we dont want it empty

@export var stored : Dictionary = {
	"ore" = 1
}
@export var capacity : int = 15

func _process(_delta: float) -> void:
	global_rotation_degrees = 0
	$Stored.refresh()
