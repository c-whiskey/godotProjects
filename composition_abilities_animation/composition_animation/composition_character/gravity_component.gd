extends Node

@export var gravity: float = 2000
@export var max_fall_speed: float = 1600
@export var fall_multiplier: float = 1.5

func physics_update(context):

	if context.is_on_floor:
		return

	if context.velocity.y > 0:
		context.velocity.y += gravity * fall_multiplier * context.delta
	else:
		context.velocity.y += gravity * context.delta

	context.velocity.y = min(context.velocity.y, max_fall_speed)
