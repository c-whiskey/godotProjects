extends Node

@export var move_speed: float = 350
@export var air_control: float = 0.15

func physics_update(context):

	if context.is_on_floor:
		context.velocity.x = context.input_dir * move_speed
	else:
		context.velocity.x = lerp(
			context.velocity.x,
			context.input_dir * move_speed,
			air_control
		)

	if context.input_dir != 0:
		context.facing_right = context.input_dir > 0
