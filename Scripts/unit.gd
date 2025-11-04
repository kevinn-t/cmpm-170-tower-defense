class_name Unit
extends CharacterBody2D

@onready var nav: NavigationAgent2D = $NavigationAgent2D
# set move speed on the nav agent

@export var home : TransportShipDepot

@export var my_container : MatContainer 
func load_container(container : MatContainer):
	container.get_parent().my_container = null
	container.reparent(self)
	my_container = container
