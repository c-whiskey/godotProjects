extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

func physics_update(delta : float):
	var input_LR = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if is_zero_approx(input_LR):
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.15)
		# unsure if I want this here..
