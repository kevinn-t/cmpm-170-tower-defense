extends Node2D

@export var package_attached : bool

# store original depot for this ship
# store package recipient

# sit idle at its depot
# if there is a package and it's full
# 	child it
#	start moving toward recipient
# after delivered
# 	come back and repeat
