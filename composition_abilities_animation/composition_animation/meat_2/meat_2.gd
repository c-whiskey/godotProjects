extends CharacterBody2D

# dead cells x meat boy

# --- Movement variables ---
@export var move_speed: float = 350
@export var jump_force: float = 700
@export var gravity: float = 2000
@export var max_fall_speed: float = 1600
@export var air_control: float = 0.15

# --- Ground Coyote Time ---
@export var coyote_time: float = 0.12
var coyote_timer: float = 0.0

# --- Wall Coyote Time ---
@export var wall_coyote_time: float = 0.15
var wall_coyote_timer: float = 0.0
var last_wall_dir: int = 0

# --- Variable jump ---
@export var jump_cut_multiplier: float = 0.5
@export var fall_gravity_multiplier: float = 1.5

# --- Wall jump ---
@export var wall_jump_force: Vector2 = Vector2(450, -650)
@export var wall_slide_speed: float = 250

# --- Dash ---
@export var dash_speed : float = 1000
@export var dash_time : float = 0.15
@export var dash_cooldown : float = 0.3
var dash_timer : float = 0
var dash_cooldown_timer : float = 0
var is_dashing : bool = false
var dash_direction : Vector2 = Vector2.ZERO

var facing_right: bool = true


func _physics_process(delta):
	var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	# --- Update Ground Coyote Timer ---
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# --- Update Wall Coyote Timer ---
	if is_on_wall_override() and not is_on_floor():
		last_wall_dir = get_wall_dir()
		wall_coyote_timer = wall_coyote_time
	else:
		wall_coyote_timer -= delta

	# --- Horizontal movement ---
	if not is_dashing:
		if is_on_floor():
			velocity.x = input_dir * move_speed
		else:
			velocity.x = lerp(velocity.x, input_dir * move_speed, air_control)

	# --- Gravity ---
	if not is_on_floor() and not is_dashing:
		if velocity.y > 0:
			velocity.y += gravity * fall_gravity_multiplier * delta
		else:
			velocity.y += gravity * delta

		velocity.y = min(velocity.y, max_fall_speed)

	# --- Jumping ---
	if Input.is_action_just_pressed("jump"):
		# Ground jump (with coyote time)
		if coyote_timer > 0:
			velocity.y = -jump_force
			coyote_timer = 0

		# Wall jump (with wall coyote time)
		elif wall_coyote_timer > 0:
			velocity.x = -last_wall_dir * wall_jump_force.x
			velocity.y = wall_jump_force.y
			wall_coyote_timer = 0

	# --- Variable jump height ---
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	# --- Wall sliding ---
	if is_on_wall_override() and not is_on_floor() and velocity.y > wall_slide_speed:
		velocity.y = wall_slide_speed

	# --- Dash ---
	dash_cooldown_timer -= delta

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	elif Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		var inVector := Vector2.ZERO
		inVector.x = input_dir
		start_dash(inVector)

	move_and_slide()

	# --- Flip sprite ---
	if input_dir != 0:
		facing_right = input_dir > 0


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


func start_dash(input_vector: Vector2):
	is_dashing = true
	dash_timer = dash_time
	dash_cooldown_timer = dash_cooldown
	dash_direction = input_vector.normalized()

	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2(sign(velocity.x), 0)

	velocity = dash_direction * dash_speed
