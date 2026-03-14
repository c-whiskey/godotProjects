extends CharacterBody2D

# ===============================
# CONFIG
# ===============================

@export var walk_speed := 180.0
@export var dash_speed := 320.0
@export var acceleration := 1400.0
@export var friction := 1200.0

@export var jump_force := 420.0
@export var double_jump_force := 380.0
@export var gravity := 1200.0
@export var fast_fall_multiplier := 1.8

@export var max_jumps := 2
@export var max_fall_speed := 900.0

@export var weight := 1.1   # Affects knockback scaling

# ===============================
# STATE
# ===============================

enum State {
	IDLE,
	RUN,
	DASH,
	JUMP,
	FALL,
	ATTACK,
	SPECIAL,
	SHIELD,
	HITSTUN
}

var state : State = State.IDLE
var facing := 1
var jumps_left := 0
var damage := 0.0
var is_fast_falling := false
var attack_locked := false
var dash_timer := 0.0

# ===============================
# READY
# ===============================

func _ready():
	jumps_left = max_jumps

# ===============================
# MAIN LOOP
# ===============================

func _physics_process(delta):
	apply_gravity(delta)
	handle_state(delta)
	move_and_slide()
	update_state()

# ===============================
# STATE MACHINE
# ===============================

func handle_state(delta):

	match state:

		State.IDLE, State.RUN:
			handle_ground_movement(delta)
			handle_jump()
			handle_attacks()
			handle_shield()

		State.DASH:
			dash_timer -= delta
			velocity.x = facing * dash_speed
			if dash_timer <= 0:
				state = State.RUN

		State.JUMP, State.FALL:
			handle_air_movement(delta)
			handle_air_attacks()
			handle_fast_fall()

		State.SHIELD:
			velocity.x = 0
			if not Input.is_action_pressed("shield"):
				state = State.IDLE

		State.HITSTUN:
			# movement handled by knockback
			pass

		State.ATTACK, State.SPECIAL:
			# locked during animations
			pass

# ===============================
# MOVEMENT
# ===============================

func handle_ground_movement(delta):

	var input_dir = Input.get_axis("move_left", "move_right")

	if input_dir != 0:
		facing = sign(input_dir)
		velocity.x = move_toward(velocity.x, input_dir * walk_speed, acceleration * delta)
		state = State.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		state = State.IDLE

	# Dash
	if Input.is_action_just_pressed("dash") and input_dir != 0:
		state = State.DASH
		dash_timer = 0.15


func handle_air_movement(delta):

	var input_dir = Input.get_axis("move_left", "move_right")

	velocity.x = move_toward(
		velocity.x,
		input_dir * walk_speed,
		acceleration * 0.6 * delta
	)

	if velocity.y > 0:
		state = State.FALL
	else:
		state = State.JUMP


func apply_gravity(delta):

	if not is_on_floor():
		var grav = gravity
		if is_fast_falling:
			grav *= fast_fall_multiplier

		velocity.y += grav * delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		jumps_left = max_jumps
		is_fast_falling = false


func handle_jump():

	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		if jumps_left == max_jumps:
			velocity.y = -jump_force
		else:
			velocity.y = -double_jump_force

		jumps_left -= 1
		state = State.JUMP


func handle_fast_fall():
	if Input.is_action_just_pressed("move_down") and velocity.y > 0:
		is_fast_falling = true


# ===============================
# ATTACKS
# ===============================

func handle_attacks():

	if attack_locked:
		return

	if Input.is_action_just_pressed("attack"):
		start_jab()

	elif Input.is_action_just_pressed("smash"):
		start_forward_smash()

	elif Input.is_action_just_pressed("special"):
		start_spin_attack()


func handle_air_attacks():

	if attack_locked:
		return

	if Input.is_action_just_pressed("attack"):
		start_neutral_air()


# -------------------------------
# JAB (3 HIT COMBO)
# -------------------------------

var jab_step := 0

func start_jab():
	state = State.ATTACK
	attack_locked = true
	jab_step += 1
	jab_step = clamp(jab_step, 1, 3)

	spawn_hitbox(Vector2(30 * facing, 0), Vector2(40, 30), 4 + jab_step, 8)

	await get_tree().create_timer(0.18).timeout

	attack_locked = false
	state = State.IDLE

	await get_tree().create_timer(0.2).timeout
	jab_step = 0


# -------------------------------
# FORWARD SMASH (Charge)
# -------------------------------

func start_forward_smash():
	state = State.ATTACK
	attack_locked = true

	var charge := 0.0

	while Input.is_action_pressed("smash"):
		charge += get_process_delta_time()
		charge = min(charge, 1.0)
		await get_tree().process_frame

	var power = lerp(12, 25, charge)
	spawn_hitbox(Vector2(45 * facing, 0), Vector2(60, 40), power, 16)

	await get_tree().create_timer(0.4).timeout
	attack_locked = false
	state = State.IDLE


# -------------------------------
# SPIN ATTACK (Up Special)
# -------------------------------

func start_spin_attack():
	state = State.SPECIAL
	attack_locked = true

	velocity.y = -500

	for i in 5:
		spawn_hitbox(Vector2(0, 0), Vector2(60, 60), 3, 6)
		await get_tree().create_timer(0.1).timeout

	await get_tree().create_timer(0.3).timeout
	attack_locked = false
	state = State.FALL


# -------------------------------
# NEUTRAL AIR
# -------------------------------

func start_neutral_air():
	state = State.ATTACK
	attack_locked = true

	spawn_hitbox(Vector2(0, 0), Vector2(70, 60), 8, 10)

	await get_tree().create_timer(0.4).timeout
	attack_locked = false
	state = State.FALL


# ===============================
# SHIELD
# ===============================

func handle_shield():
	if Input.is_action_pressed("shield"):
		state = State.SHIELD


# ===============================
# HITBOX SYSTEM
# ===============================

func spawn_hitbox(offset: Vector2, size: Vector2, dmg: float, kb: float):

	var hitbox = Area2D.new()
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()

	rect.size = size
	shape.shape = rect
	hitbox.add_child(shape)

	hitbox.position = offset
	hitbox.set("damage", dmg)
	hitbox.set("knockback", kb)

	hitbox.body_entered.connect(_on_hitbox_body_entered.bind(hitbox))

	$Hitboxes.add_child(hitbox)

	await get_tree().create_timer(0.08).timeout
	hitbox.queue_free()


func _on_hitbox_body_entered(body, hitbox):

	if body.has_method("apply_knockback"):
		body.apply_knockback(
			facing,
			hitbox.get("damage"),
			hitbox.get("knockback")
		)

# ===============================
# DAMAGE / KNOCKBACK
# ===============================

func apply_knockback(direction, dmg, base_kb):

	damage += dmg

	var scaling = 1 + (damage / 100.0)
	var total_kb = base_kb * scaling / weight

	velocity.x = direction * total_kb * 25
	velocity.y = -total_kb * 20

	state = State.HITSTUN

	await get_tree().create_timer(0.4).timeout
	state = State.FALL


# ===============================
# STATE UPDATE
# ===============================

func update_state():
	if is_on_floor() and state == State.FALL:
		state = State.IDLE
