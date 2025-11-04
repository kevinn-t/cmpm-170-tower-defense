extends Node2D
class_name StorageUI

func refresh():
	var stored = get_parent().stored
	for k in stored.keys():
		var n = $VBoxContainer.get_node(NodePath(k))
		n.get_node("Label").text = str(stored[k])
		n.visible = stored[k] != 0
