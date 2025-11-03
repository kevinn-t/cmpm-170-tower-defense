extends CharacterBody2D

@onready var target = null
@export var health = 10
@export var damage = 1
@export var speed = 150

@onready var buildingsNode = $"../Buildings"
var buildings = []
var minDistance = INF

func _ready() -> void:
	_get_nearest_target()

func _process(_delta: float) -> void:
	_get_nearest_target()
	
func _physics_process(_delta: float) -> void:
	if (target != null):
		var direction = (target.position - position).normalized()
		velocity = direction * speed
		move_and_slide()

func _get_nearest_target():
	buildings = buildingsNode.get_children()
	for building in buildings:
		var distance = position.distance_to(building.position)
		if (distance < minDistance):
			minDistance = distance
			target = building

func take_damage(dmg: float):
	health -= dmg
	if (health <= 0):
		queue_free()
