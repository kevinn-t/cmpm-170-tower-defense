class_name RepairShip
extends Unit

@onready var target : Building = null
@export var home_radius = 1
@export var dest_radius = 50
# integrity (in unit) is hp
@export var healingEffect = 200
# set speed in nav agent


func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	#eval_state()
	pass
	
func eval_state(delta):
	if target != null && not is_instance_valid(target):
		target = null
	if target != null and target.integrity >= target.max_integrity:
		target = null
	
	if target != null && nav.is_navigation_finished():
		current_state = State.REPAIRING
	elif target != null:
		current_state = State.SEEKING
	elif not nav.is_navigation_finished():
		current_state = State.RETURNING
	else:
		current_state = State.IDLE
	
	repair_beam(current_state == State.REPAIRING, delta)
	#$Status.text = str(current_state) + " " + str(target.integrity >= target.max_integrity)

func repair_beam(on:bool, delta:float):
	$RepairBeam.visible = on
	if on && target != null:
		$RepairBeam.points = [Vector2.ZERO, to_local(target.global_position)]
		
		# actually do the repair
		target.integrity += healingEffect * delta
		#print(target.integrity)
		target.integrity = clamp(target.integrity, 0, target.max_integrity)
		target.onRepaired.emit()

enum State { IDLE, SEEKING, RETURNING, REPAIRING }
var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
	
	eval_state(delta)
	if target != null:
		nav.target_position = target.global_position
		nav.target_desired_distance = dest_radius
	elif home != null:
		nav.target_position = home.global_position
		nav.target_desired_distance = home_radius
	else:
		return
	
	if not nav.is_navigation_finished():
		var direction: Vector2 = global_position.direction_to(nav.get_next_path_position())
		velocity = direction * nav.max_speed
	else:
		velocity = Vector2.ZERO
		
	nav.set_velocity(velocity * nav.max_speed)
	move_and_slide()
	
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
	
	super(delta)
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	#velocity = safe_velocity
	pass
	#print("Safe velocity " + str(safe_velocity))
	#move_and_slide()
