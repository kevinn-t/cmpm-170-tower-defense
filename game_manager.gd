extends Node

@export var money : int = 100
@export var unemployed_population: int = 10
@export var total_population: int = 10


func assign_workers(amount: int) -> void:
	if (unemployed_population - amount > 0):
		unemployed_population -= amount
