class_name  TransportShip
extends Unit


@export var package_attached : bool


enum State { IDLE, TRANSPORTING, RETURNING }
var current_state: State = State.IDLE

var homeDist = 10.0
const state_flavor_text = [
	"Idle",
	"Transporting",
	"Returning Home"
]


var nearHome:
	get:
		return global_position.distance_to(home.global_position) < homeDist

func _physics_process(_delta: float) -> void:
	# if no home, die
	if home == null:
		velocity = Vector2.ZERO
		queue_free()
		return

	match current_state:
		State.IDLE:
			if not nearHome:
				current_state = State.RETURNING
				nav.target_position = home.global_position
			elif home.hasContainer() and home.destination: 
				load_container(home.my_container)
				current_state = State.TRANSPORTING
				nav.target_position = home.destination.global_position
			else:
				nav.target_position = home.global_position

		State.TRANSPORTING:
			my_container.global_position = global_position - Vector2(24,0)
			if nav.is_navigation_finished():
				home.destination.recieve_delivery(my_container)
				current_state = State.RETURNING
				nav.target_position = home.global_position

		State.RETURNING:
			if nav.is_navigation_finished() or nearHome:
				current_state = State.IDLE
	
	if not nav.is_navigation_finished():
		var direction: Vector2 = global_position.direction_to(nav.get_next_path_position())
		velocity = direction
	else:
		velocity = Vector2.ZERO
	#print("vel " + str(velocity))
	nav.set_velocity(velocity * nav.max_speed)
	rotation = lerp_angle(rotation, atan2(velocity.y, velocity.x), turn_speed * _delta)
	
	$Status.text = str(state_flavor_text[current_state]) + "\n" + str(nearHome)
	$Status.global_position = global_position + Vector2(-$Status.size.x * $Status.scale.x * 0.5,10)
	$Status.rotation = rotation * -1
	
	velocity = nav.velocity
	move_and_slide()
	super(_delta)

func _mouse_enter() -> void:
	$Status.visible = true
func _mouse_exit() -> void:
	$Status.visible = true


func _on_navigation_agent_2d_navigation_finished() -> void:
	pass # Replace with function body.

func _on_navigation_agent_2d_velocity_computed(_safe_velocity: Vector2) -> void:
	#velocity = safe_velocity
	##print("Safe velocity " + str(safe_velocity))
	#move_and_slide()
	pass
