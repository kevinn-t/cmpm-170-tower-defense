class_name Enemy
extends Unit

@onready var target : Node2D = null
# integrity (in unit) is hp
@export var damage = 1
# set speed in nav agent

@onready var bulletParent = $"../../Bullets"
@onready var buildingsNode = $"../../Buildings"
var buildings = []
var minDistance = INF

func _ready() -> void:
	_get_nearest_target()
	for c in get_children():
		if c is Gun:
			c.bulletParent = bulletParent

func _process(_delta: float) -> void:
	#eval_state()
	pass
	
func eval_state():
	if target != null && not is_instance_valid(target):
		target = null
	
	if target != null && nav.is_navigation_finished():
		current_state = State.ATTACKING
	elif target != null:
		current_state = State.SEEKING
	else:
		current_state = State.IDLE
	
	match  current_state:
		State.IDLE:
			_get_nearest_target()
			fire_guns(false)
		State.SEEKING:
			fire_guns(false)
		State.ATTACKING:
			fire_guns(true)
	
	if target != null && is_instance_valid(target): # guns may have invalidated the target
		nav.target_position = target.global_position

func fire_guns(yes : bool):
	for c in get_children():
		if c is Gun:
			if yes:
				c.target = target
				#c.fire()
			else:
				c.target = null
			c.set_firing(yes)

enum State { IDLE, SEEKING, ATTACKING }
var current_state: State = State.IDLE

func _get_nearest_target():
	buildings = buildingsNode.get_children()
	for building in buildings:
		var distance = position.distance_to(building.position)
		if (distance < minDistance):
			minDistance = distance
			target = building

func _physics_process(_delta: float) -> void:
	
	eval_state()
	if not nav.is_navigation_finished():
		var direction: Vector2 = global_position.direction_to(nav.get_next_path_position())
		velocity = direction
	else:
		velocity = Vector2.ZERO
		
	nav.set_velocity(velocity * nav.max_speed)
	
	match  current_state:
		State.IDLE:
			pass
		State.SEEKING:
			rotation = atan2(velocity.y, velocity.x)
		State.ATTACKING:
			var dir = (target.global_position - global_position).normalized()
			rotation = atan2(dir.y, dir.x)
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	#print("Safe velocity " + str(safe_velocity))
	move_and_slide()
