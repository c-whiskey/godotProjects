extends CharacterBody2D

# --- Movement variables ---
@export var move_speed: float = 300
@export var jump_force: float = 600
@export var gravity: float = 1800
@export var max_fall_speed: float = 1500
@export var air_control: float = 0.1

# --- Wall jump ---
@export var wall_jump_force: Vector2 = Vector2(400, -600)
@export var wall_slide_speed: float = 200

# Internal state
#var velocity: Vector2 = Vector2.ZERO
var facing_right: bool = true

func _physics_process(delta):
	var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	# --- Horizontal movement ---
	if is_on_floor():
		velocity.x = input_dir * move_speed
	else:
		# Air control
		velocity.x = lerp(velocity.x, input_dir * move_speed, air_control)

	# --- Gravity ---
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		velocity.y = 0

	# --- Jumping ---
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
		elif is_on_wall_override():
			# Wall jump
			var wall_dir = get_wall_dir()
			velocity.x = -wall_dir * wall_jump_force.x
			velocity.y = wall_jump_force.y

	# --- Wall sliding ---
	if is_on_wall_override() and not is_on_floor() and velocity.y > wall_slide_speed:
		velocity.y = wall_slide_speed

	# --- Move the character ---
	#velocity = move_and_slide(velocity, Vector2.UP)
	move_and_slide()
	# --- Flip sprite ---
	if input_dir != 0:
		facing_right = input_dir > 0
		$Sprite.flip_h = not facing_right

# --- Helper function ---
func is_on_wall_override() -> bool:
	return is_on_wall_left() or is_on_wall_right()
	

func is_on_wall_left() -> bool:
	return test_move(global_transform, Vector2(-1, 0) * 1)

func is_on_wall_right() -> bool:
	return test_move(global_transform, Vector2(1, 0) * 1)

func get_wall_dir() -> int:
	if is_on_wall_left():
		return -1
	elif is_on_wall_right():
		return 1
	return 0
