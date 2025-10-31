extends StaticBody2D

# needs to start with 1 because depots check for an existing containter & +1 ot it
# BEFORE it has the chance to spawn one so when it does, it would normally be empty
# but we dont want it empty
@export var ore_stored : int = 1
@export var max_ore : int = 15
