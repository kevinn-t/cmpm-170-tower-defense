extends Node2D

@export var money: int = 100
@export var total_population: int = 10
@export var residing_population: int = 10
	
func assign_personel() -> void:
	residing_population -= 1

func upgrade() -> void:
	total_population += 5
