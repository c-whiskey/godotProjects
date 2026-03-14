extends Node

@export var wall_slide_speed: float = 250
@export var wall_coyote_time: float = 0.15

var wall_timer: float = 0.0
var last_wall_dir: int = 0

func physics_update(context):

	var on_wall = context.is_on_wall_left or context.is_on_wall_right

	if on_wall and not context.is_on_floor:
		last_wall_dir = -1 if context.is_on_wall_left else 1
		wall_timer = wall_coyote_time
	else:
		wall_timer -= context.delta

	if on_wall and context.velocity.y > wall_slide_speed:
		context.velocity.y = wall_slide_speed

	context.set_meta("can_wall_jump", wall_timer > 0)
	context.set_meta("wall_dir", last_wall_dir)
