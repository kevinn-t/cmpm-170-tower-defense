extends Building

@onready var gm = $"../.."

func _ready() -> void:
	onBuilt.connect(on_built)
	
func on_built()->void:
	gm.all_buildings[grid_pos()] = self

func _on_delivery() -> void:
	pass
	#gm.stored["ore"] = add_storages(gm.stored, delivery)
