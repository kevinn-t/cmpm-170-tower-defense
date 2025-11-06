extends Label

var time_lapsed : float = 0

func _process(delta: float) -> void:
	time_lapsed += delta
	text = "Survive As Long As You Can\n" + str(snapped(time_lapsed, 0.01))
