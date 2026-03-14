extends CharacterBody2D

#
# STATES
#

enum PlayerState {
	IDLE,
	MOVE,
	RUN,
	JUMP,
	FALL,
	ROLL,
	ATTACK,
	RUN_ATTACK,
	UP_ATTACK,
	DOWN_ATTACK,
	HEAVY_ATTACK,
	WALL_JUMP,
	WALL_SLIDE,
	DASH
}

var state : PlayerState = PlayerState.IDLE



# MOVEMENT TUNING
@export var walk_speed := 120
@export var run_speed := 220

@export var acceleration := 1200
@export var friction := 1500
@export var air_acceleration := 600

@export var gravity := 900

@export var jump_force := -320
@export var jump_cut_multiplier := 0.5

# DASH
@export var dash_speed := 400
@export var dash_time := 0.18

var dash_timer := 0
var can_dash := true

# WALL SLIDE
@export var wall_slide_speed := 60
@export var wall_jump_push := 220

# INPUT BUFFER
enum BufferedAction {
	NONE,
	ROLL,
	ATTACK,
	HEAVY_ATTACK
}

var buffered_action = BufferedAction.NONE
var buffer_timer := 0.0
@export var input_buffer_time := 0.2

# JUMP BUFFER + COYOTE
@export var jump_buffer_time := 0.15
@export var coyote_time := 0.1

var jump_buffer_timer := 0.0
var coyote_timer := 0.0

# INPUT CACHE
var move_input := 0.0
var vertical_input := 0.0
var is_running := false

# NODES
@onready var anim:= $AnimatedSprite2D

# READY
func _ready():
	anim.animation_finished.connect(_on_animation_finished)


# MAIN LOOP
func _physics_process(delta):
	$RichTextLabel.text = PlayerState.keys()[state]
	
	_update_input_buffer(delta)
	
	_update_jump_timers(delta)
	
	_read_inputs()
	
	_process_state(delta)
	
	_try_buffered_jump()
	
	move_and_slide()


# INPUT
func _read_inputs():

	move_input = Input.get_axis("move_left","move_right")
	vertical_input = Input.get_axis("move_up","move_down")
	is_running = Input.is_action_pressed("run")

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y *= jump_cut_multiplier # move to intent_jump?

	if Input.is_action_just_pressed("dash"):
		intent_dash()

	if Input.is_action_just_pressed("roll"):
		if is_state_locked():
			_store_buffer(BufferedAction.ROLL)
		else:
			intent_roll()

	if Input.is_action_just_pressed("attack"):
		if is_state_locked():
			_store_buffer(BufferedAction.ATTACK)
		else:
			_resolve_attack()

# STATE MACHINE
func _process_state(delta):

	_apply_gravity(delta)

	match state:

		PlayerState.IDLE:
			_state_idle(delta)

		PlayerState.MOVE:
			_state_move(delta)

		PlayerState.RUN:
			_state_run(delta)

		PlayerState.JUMP:
			_state_jump()

		PlayerState.FALL:
			_state_fall()

		PlayerState.WALL_SLIDE:
			_state_wall_slide()

		PlayerState.WALL_JUMP:
			_state_wall_jump()

		PlayerState.DASH:
			_state_dash(delta)

		PlayerState.ROLL:
			anim.play("roll")

		PlayerState.ATTACK:
			anim.play("attack")

		PlayerState.RUN_ATTACK:
			anim.play("run_attack")

		PlayerState.UP_ATTACK:
			anim.play("attack_up")

		PlayerState.DOWN_ATTACK:
			anim.play("attack_down")

		PlayerState.HEAVY_ATTACK:
			anim.play("heavy_attack")


# MOVEMENT STATES
func _state_idle(delta):

	anim.play("idle")

	_apply_friction(delta)

	if not is_on_floor():
		change_state(PlayerState.FALL)
		return

	if abs(move_input) > 0.1:
		change_state(PlayerState.MOVE)


func _state_move(delta):

	anim.play("walk")

	_apply_acceleration(delta, walk_speed)

	if abs(move_input) < 0.1:
		change_state(PlayerState.IDLE)

	if is_running:
		change_state(PlayerState.RUN)


func _state_run(delta):

	anim.play("run")

	_apply_acceleration(delta, run_speed)

	if not is_running:
		change_state(PlayerState.MOVE)

	if abs(move_input) < 0.1:
		change_state(PlayerState.IDLE)


func _state_jump():
	
	anim.play("jump")

	if velocity.y > 0:
		change_state(PlayerState.FALL)


func _state_fall():

	anim.play("fall")

	if is_on_floor():
		can_dash = true
		change_state(PlayerState.IDLE)

	if is_on_wall() and move_input != 0:
		change_state(PlayerState.WALL_SLIDE)


func _state_wall_slide():

	anim.play("wall_slide")

	velocity.y = min(velocity.y, wall_slide_speed)

	if not is_on_wall():
		change_state(PlayerState.FALL)

	if Input.is_action_just_pressed("jump"):
		intent_wall_jump()


func _state_wall_jump():
	anim.play("wall_jump")

	if velocity.y > 0:
		change_state(PlayerState.FALL)


# DASH
func _state_dash(delta):

	anim.play("dash")

	dash_timer -= delta

	if dash_timer <= 0:
		change_state(PlayerState.FALL)


func intent_dash():

	if not can_dash:
		return

	can_dash = false

	dash_timer = dash_time
	state = PlayerState.DASH

	velocity.y = 0
	velocity.x = move_input * dash_speed

	if move_input == 0:
		velocity.x = dash_speed * sign(scale.x)

# WALL JUMP
func intent_wall_jump():

	var wall_dir = get_wall_normal().x

	velocity.y = jump_force
	velocity.x = wall_dir * wall_jump_push

	state = PlayerState.WALL_JUMP


# MOVEMENT HELPERS
func _apply_acceleration(delta, max_speed):

	var accel = acceleration if is_on_floor() else air_acceleration

	velocity.x = move_toward(
		velocity.x,
		move_input * max_speed,
		accel * delta
	)


func _apply_friction(delta):

	velocity.x = move_toward(
		velocity.x,
		0,
		friction * delta
	)


func _apply_gravity(delta):

	if not is_on_floor():
		velocity.y += gravity * delta


# JUMP
func intent_jump():

	if coyote_timer > 0:
		velocity.y = jump_force
		change_state(PlayerState.JUMP)

	elif is_on_wall():
		intent_wall_jump()


# BUFFER
func _update_input_buffer(delta):
	if buffer_timer > 0:
		buffer_timer -= delta

	if buffer_timer <= 0:
		buffered_action = BufferedAction.NONE


func _store_buffer(action):

	buffered_action = action
	buffer_timer = input_buffer_time


func _consume_buffer():

	match buffered_action:

		BufferedAction.ROLL:
			intent_roll()

		BufferedAction.ATTACK:
			intent_attack()

	buffered_action = BufferedAction.NONE


# JUMP TIMERS
func _update_jump_timers(delta):

	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta


func _try_buffered_jump():

	if jump_buffer_timer > 0 and coyote_timer > 0:
		jump_buffer_timer = 0
		intent_jump()


# STATE CONTROL
func change_state(new_state):

	if state == new_state:
		return

	if is_state_locked():
		return

	state = new_state


func is_state_locked():

	return state in [
		PlayerState.ROLL,
		PlayerState.ATTACK,
		PlayerState.RUN_ATTACK,
		PlayerState.UP_ATTACK,
		PlayerState.DOWN_ATTACK,
		PlayerState.HEAVY_ATTACK
	]


# ATTACK RESOLUTION
func _resolve_attack():

	var up := vertical_input < -0.5
	var down := vertical_input > 0.5
	var moving := float(abs(move_input) > 0.2)

	if up:
		change_state(PlayerState.UP_ATTACK)
	elif down:
		change_state(PlayerState.DOWN_ATTACK)
	elif moving and is_running:
		change_state(PlayerState.RUN_ATTACK)
	else:
		change_state(PlayerState.ATTACK)


# INTENTS
func intent_roll():
	change_state(PlayerState.ROLL)

func intent_attack():
	change_state(PlayerState.ATTACK)


# ANIMATION FINISHED
func _on_animation_finished():

	match state:
		PlayerState.ROLL, \
		PlayerState.ATTACK, \
		PlayerState.RUN_ATTACK, \
		PlayerState.UP_ATTACK, \
		PlayerState.DOWN_ATTACK, \
		PlayerState.HEAVY_ATTACK:
			state = PlayerState.IDLE
			_consume_buffer()
