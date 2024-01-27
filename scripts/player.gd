extends CharacterBody3D

@export var camera: Camera3D

@export var speed: float = 5
var input_direction: Vector2

var relative_input_direction: Vector3:
	get:
		if camera == null:
			return Vector3(input_direction.x, input_direction.y, 0)
		else:
			
			var forward = camera.global_transform.basis.z
			forward.y = 0
			# Forward is -z, so negate
			forward = -forward.normalized()
			
			var right = camera.global_transform.basis.x
			right.y = 0
			return right * input_direction.x + forward * input_direction.y

func _process(delta):
	
	input_direction = Vector2.ZERO
	if Input.is_action_pressed("game_forward"):
		input_direction += Vector2(0, 1)
		
	if Input.is_action_pressed("game_back"):
		input_direction += Vector2(0, -1)
		
	if Input.is_action_pressed("game_left"):
		input_direction += Vector2(-1, 0)
		
	if Input.is_action_pressed("game_right"):
		input_direction += Vector2(1, 0)
		
func _physics_process(delta):
	
	var move_vel = relative_input_direction * speed
	velocity.x = move_vel.x
	velocity.z = move_vel.z

	# Gravity
	if not is_on_floor():
		velocity.y += -9.8 * delta
	else:
		velocity.y = 0
		
	move_and_slide()
