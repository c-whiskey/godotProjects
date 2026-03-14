extends Node

@export var dash_speed : float = 1000
@export var dash_time : float = 0.15
@export var dash_cooldown : float = 0.3

var dash_timer : float = 0
var cooldown_timer : float = 0
var is_dashing : bool = false
var dash_direction : Vector2 = Vector2.ZERO

func physics_update(context):

	cooldown_timer -= context.delta

	if is_dashing:
		dash_timer -= context.delta
		context.velocity = dash_direction * dash_speed

		if dash_timer <= 0:
			is_dashing = false
		return

	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:

		dash_direction = Vector2(context.input_dir, 0).normalized()

		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(sign(context.velocity.x), 0)

		is_dashing = true
		dash_timer = dash_time
		cooldown_timer = dash_cooldown
