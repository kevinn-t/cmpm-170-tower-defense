extends Building
@onready var gm = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	onBuilt.connect(on_built)

func on_built()->void:
	gm.all_buildings[grid_pos()] = self
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
