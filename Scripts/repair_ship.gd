class_name RepairShip
extends Unit

@onready var target : Building = null
# integrity (in unit) is hp
@export var healingEffect = 100
# set speed in nav agent


func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	#eval_state()
	pass
	
func eval_state(delta):
	if target != null && not is_instance_valid(target):
		target = null
	
	if target != null && nav.is_navigation_finished():
		current_state = State.REPAIRING
	elif target != null:
		current_state = State.SEEKING
	elif target == null && not nav.is_navigation_finished():
		current_state = State.RETURNING
	else:
		current_state = State.IDLE
	
	repair_beam(current_state == State.REPAIRING, delta)

func repair_beam(on:bool, delta:float):
	$RepairBeam.visible = on
	if on && target != null:
		$RepairBeam.points = [Vector2.ZERO, to_local(target.global_position)]
		
		# actually do the repair
		target.integrity += healingEffect * delta
		target.integrity = clamp(target.integrity, 0, target.max_integrity)

enum State { IDLE, SEEKING, RETURNING, REPAIRING }
var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
	super(delta)
	if target != null:
		nav.target_position = target.global_position
	elif home != null:
		nav.target_position = home.global_position
	else:
		return
	
	eval_state(delta)
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
		State.RETURNING:
			rotation = atan2(velocity.y, velocity.x)
		State.REPAIRING:
			var dir = (target.global_position - global_position).normalized()
			rotation = atan2(dir.y, dir.x)
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	#print("Safe velocity " + str(safe_velocity))
	move_and_slide()
