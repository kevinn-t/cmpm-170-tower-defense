extends Building

# how much ore/sec this would pull from adjacent ore producers
@export var ore_pull_speed : int 

@export var ore_stored : int = 1
@export var max_ore_stored : int = 10
@export var workers : int = 0
@export var max_workers : int = 2
@export var ship_away : bool = false


func _process(_delta: float) -> void:
	ore_pull_speed = workers # PLACEHOLDER make this scale by pecentage at some point
	
	# if theres a worker
	#	if theres a package above
	#		push ore into package
	#	otherwise
	# 		make new package
