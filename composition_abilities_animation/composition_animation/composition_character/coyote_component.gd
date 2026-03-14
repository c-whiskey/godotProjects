extends Node

@export var coyote_time: float = 0.12
var timer: float = 0.0

func physics_update(context):

	if context.is_on_floor:
		timer = coyote_time
	else:
		timer -= context.delta

	context.set_meta("can_ground_jump", timer > 0)
