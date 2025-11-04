class_name Enemy
extends Unit

@onready var target = null
@export var health = 10
@export var damage = 1
# set speed in nav agent

@onready var buildingsNode = $"../Buildings"
var buildings = []
var minDistance = INF

func _ready() -> void:
	_get_nearest_target()

func _process(_delta: float) -> void:
	_get_nearest_target()
	

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

func _physics_process(_delta: float) -> void:
	if not nav.is_navigation_finished():
		var direction: Vector2 = global_position.direction_to(nav.get_next_path_position())
		velocity = direction
	else:
		velocity = Vector2.ZERO
		
	nav.set_velocity(velocity * nav.max_speed)
	rotation = atan2(velocity.y, velocity.x)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	#print("Safe velocity " + str(safe_velocity))
	move_and_slide()
