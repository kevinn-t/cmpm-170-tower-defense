extends Building

var game_manager : Node

@onready var gm : GameManager = $"../.."

func _on_delivery(ore: Variant) -> void:
	gm.stored["ore"] += ore
