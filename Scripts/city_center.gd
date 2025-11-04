extends Building

var game_manager : Node

@onready var gm : GameManager = $"../.."

func _on_delivery() -> void:
	pass
	#gm.stored["ore"] = add_storages(gm.stored, delivery)
