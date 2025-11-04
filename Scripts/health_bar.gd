extends Node2D
class_name HealthBar

func refresh():
	var n : Node = get_parent()
	$Bar.max_value = n.max_integrity
	$Bar.value = n.integrity
	#visible = n.integrity == n.max_integrity
