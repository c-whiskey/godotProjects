extends CharacterBody2D

# Movement
@export var speed : float = 400
@export var acceleration : float = 2000
@export var friction : float = 1500

# Jumping
@export var jump_velocity : float = -650
@export var gravity : float = 2000
@export var max_fall_speed : float = 1200
@export var coyote_time : float = 0.1
var coyote_timer : float = 0

# Wall Jump
@export var wall_jump_velocity : Vector2 = Vector2(400, -500)
var is_touching_wall : bool = false
var wall_dir : int = 0

# Dash
@export var dash_speed : float = 800
@export var dash_time : float = 0.15
@export var dash_cooldown : float = 0.3
var dash_timer : float = 0
var dash_cooldown_timer : float = 0
var is_dashing : bool = false
var dash_direction : Vector2 = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# Gravity
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	# Coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Horizontal movement (unless dashing)
	if not is_dashing:
		if input_vector.x != 0:
			velocity.x = move_toward(velocity.x, input_vector.x * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Jump
	if Input.is_action_just_pressed("jump"):
		if coyote_timer > 0:
			velocity.y = jump_velocity
			coyote_timer = 0
		elif is_touching_wall:
			# Wall jump
			velocity.y = wall_jump_velocity.y
			velocity.x = -wall_dir * wall_jump_velocity.x

	# Wall detection
	is_touching_wall = is_on_wall()
	if is_touching_wall:
		#wall_dir = get_last_slide_collision().normal.x
		pass

	# Dash
	dash_cooldown_timer -= delta
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	elif Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		start_dash(input_vector)

	move_and_slide()

func start_dash(input_vector: Vector2):
	is_dashing = true
	dash_timer = dash_time
	dash_cooldown_timer = dash_cooldown
	dash_direction = input_vector.normalized()
	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2(sign(velocity.x), 0)
	velocity = dash_direction * dash_speed
