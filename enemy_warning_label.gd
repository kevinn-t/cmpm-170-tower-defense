extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "Time left until next wave:\n" + str(snapped($"../../EnemySpawner/Timer".time_left, 0.01))
