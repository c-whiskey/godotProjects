extends Node

@export var jump_force: float = 700
@export var wall_jump_force: Vector2 = Vector2(450, -650)
@export var jump_cut_multiplier: float = 0.5

func physics_update(context):

	if Input.is_action_just_pressed("jump"):

		if context.get_meta("can_ground_jump", false):
			context.velocity.y = -jump_force

		elif context.get_meta("can_wall_jump", false):
			var dir = context.get_meta("wall_dir", 0)
			context.velocity.x = -dir * wall_jump_force.x
			context.velocity.y = wall_jump_force.y

	if Input.is_action_just_released("jump") and context.velocity.y < 0:
		context.velocity.y *= jump_cut_multiplier
