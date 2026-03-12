extends CharacterBody2D

# dead cells x meat boy

# --- Movement variables ---
@export var move_speed: float = 125
@export var jump_force: float = 300
@export var gravity: float = 1000
@export var max_fall_speed: float = 500
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
@export var fall_gravity_multiplier: float = 1

# --- Wall jump ---
@export var wall_jump_force: Vector2 = Vector2(300, -355)
@export var wall_slide_speed: float = 175

# --- Dash ---
@export var dash_speed: float = 300
@export var dash_time: float = 0.15
@export var dash_cooldown: float = 0.3
var dash_timer: float = 0
var dash_cooldown_timer: float = 0
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO

# --- Kick ---
@export var kick_time: float = 0.25
@export var kick_cooldown: float = 0.3
@export var kick_forward_force: float = 100
var kick_timer: float = 0
var kick_cooldown_timer: float = 0
var is_kicking: bool = false

# --- Facing ---
var facing_right: bool = true
var facing = 1

# --- Animation ---
@onready var anim: AnimationPlayer = $SubViewportContainer/SubViewport/Armature/AnimationPlayer3

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

	# --- Cooldowns ---
	dash_cooldown_timer -= delta
	kick_cooldown_timer -= delta

	# --- Kick Logic ---
	if is_kicking:
		kick_timer -= delta
		velocity.x = facing * kick_forward_force
		velocity.y = 0

		if kick_timer <= 0:
			is_kicking = false

	elif Input.is_action_just_pressed("kick") and kick_cooldown_timer <= 0:
		start_kick()

	# --- Horizontal movement ---
	if not is_dashing and not is_kicking:
		if is_on_floor():
			velocity.x = input_dir * move_speed
		else:
			velocity.x = lerp(velocity.x, input_dir * move_speed, air_control)

	# --- Gravity ---
	if not is_on_floor() and not is_dashing and not is_kicking:
		if velocity.y > 0:
			velocity.y += gravity * fall_gravity_multiplier * delta
		else:
			velocity.y += gravity * delta

		velocity.y = min(velocity.y, max_fall_speed)

	# --- Jumping ---
	if Input.is_action_just_pressed("jump") and not is_kicking:
		# Ground jump
		if coyote_timer > 0:
			velocity.y = -jump_force
			coyote_timer = 0
			anim.play("UAL1_animations/Jump")

		# Wall jump
		elif wall_coyote_timer > 0:
			velocity.x = -last_wall_dir * wall_jump_force.x
			velocity.y = wall_jump_force.y
			wall_coyote_timer = 0
			anim.play("anim__Jump From Wall/mixamo_com")

	# --- Variable jump height ---
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	# --- Wall sliding ---
	var is_wall_sliding = false
	if is_on_wall_override() and not is_on_floor() and velocity.y > wall_slide_speed:
		velocity.y = wall_slide_speed
		is_wall_sliding = true

	# --- Dash ---
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	elif Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_kicking:
		var inVector := Vector2.ZERO
		inVector.x = input_dir
		start_dash(inVector)
		anim.play("UAL1_animations/Roll")

	move_and_slide()

	# --- Flip sprite ---
	if input_dir != 0:
		facing_right = input_dir > 0
		facing = Input.get_axis("move_left", "move_right")

	update_facing(delta)

	# --- Animation State Machine ---
	update_animation(input_dir, is_wall_sliding)


# ==============================
# Animation State Machine
# ==============================
func update_animation(input_dir: float, is_wall_sliding: bool):

	# Kick has highest priority
	if is_kicking:
		if anim.current_animation != "anim__Standing Melee Kick/mixamo_com":
			anim.play("anim__Standing Melee Kick/mixamo_com")
		return

	# Dash
	if is_dashing:
		if anim.current_animation != "UAL1_animations/Roll":
			anim.play("UAL1_animations/Roll")
		return

	# Wall slide
	if is_wall_sliding:
		if anim.current_animation != "anim__Hanging Idle (1)/mixamo_com":
			anim.play("anim__Hanging Idle (1)/mixamo_com")
		return

	# Air states
	if not is_on_floor():
		if velocity.y < 0:
			if anim.current_animation != "UAL1_animations/Jump":
				anim.play("UAL1_animations/Jump")
		else:
			if anim.current_animation != "UAL1_animations/Jump":
				anim.play("UAL1_animations/Jump")
		return

	# Ground states
	if abs(input_dir) > 0:
		if anim.current_animation != "runningAnimation/mixamo_com":
			anim.play("runningAnimation/mixamo_com")
	else:
		if anim.current_animation != "UAL1_animations/Sword_Idle":
			anim.play("UAL1_animations/Sword_Idle")


# ==============================
# Dash Logic
# ==============================
func start_dash(input_vector: Vector2):
	is_dashing = true
	dash_timer = dash_time
	dash_cooldown_timer = dash_cooldown
	dash_direction = input_vector.normalized()

	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2(sign(velocity.x), 0)

	velocity = dash_direction * dash_speed


# ==============================
# Kick Logic
# ==============================
func start_kick():
	is_kicking = true
	kick_timer = kick_time
	kick_cooldown_timer = kick_cooldown
	velocity.y = 0
	anim.play("anim__Standing Melee Kick/mixamo_com")
	for char in $Area2D.get_overlapping_bodies():
		if char is RigidBody2D:
			char.apply_impulse((Vector2.UP*4 + $Area2D.position) *50 )
			

# ==============================
# Wall detection helpers
# ==============================
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


func update_facing(delta):
	$SubViewportContainer/SubViewport/Armature.look_at(Vector3.FORWARD * facing, Vector3.UP)
	$Area2D.position.x = absf($Area2D.position.x) * facing
