extends CharacterBody2D
# this is really good!
# --- Movement variables ---
@export var move_speed: float = 350
@export var jump_force: float = 700
@export var gravity: float = 2000
@export var max_fall_speed: float = 1600
@export var air_control: float = 0.15

# --- Variable jump ---
@export var jump_cut_multiplier: float = 0.5   # How much upward velocity is kept when releasing jump
@export var fall_gravity_multiplier: float = 1.5  # Faster falling for snappier feel

# --- Wall jump ---
@export var wall_jump_force: Vector2 = Vector2(450, -650)
@export var wall_slide_speed: float = 250

var facing_right: bool = true

func _physics_process(delta):
	var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	# --- Horizontal movement ---
	if is_on_floor():
		velocity.x = input_dir * move_speed
	else:
		velocity.x = lerp(velocity.x, input_dir * move_speed, air_control)

	# --- Gravity ---
	if not is_on_floor():
		# Apply stronger gravity when falling
		if velocity.y > 0:
			velocity.y += gravity * fall_gravity_multiplier * delta
		else:
			velocity.y += gravity * delta

		velocity.y = min(velocity.y, max_fall_speed)

	# --- Jumping ---
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
		elif is_on_wall_override():
			var wall_dir = get_wall_dir()
			velocity.x = -wall_dir * wall_jump_force.x
			velocity.y = wall_jump_force.y

	# --- Variable jump height (jump cut) ---
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	# --- Wall sliding ---
	if is_on_wall_override() and not is_on_floor() and velocity.y > wall_slide_speed:
		velocity.y = wall_slide_speed

	move_and_slide()

	# --- Flip sprite ---
	if input_dir != 0:
		facing_right = input_dir > 0
		#$Sprite2D.flip_h = not facing_right
	# perfecto

# --- Wall detection helpers ---
func is_on_wall_override() -> bool:
	return is_on_wall_left() or is_on_wall_right()

func is_on_wall_left() -> bool:
	return test_move(global_transform, Vector2.LEFT)

func is_on_wall_right() -> bool:
	return test_move(global_transform, Vector2.RIGHT)

func get_wall_dir() -> int:
	if is_on_wall_left():
		return -1
	elif is_on_wall_right():
		return 1
	return 0
