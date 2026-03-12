extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

# move speed is duplicated in this script and the run gd script
# TODO
@export var move_speed: float = 350
@export var air_control: float = 0.15

func physics_update(delta : float):
	if moveController.currentAction == moveController.playerAction.FALLING ||\
	moveController.currentAction == moveController.playerAction.JUMP_ABILITY:
		pass
	else:
		return

	var input_LR = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	player.velocity.x = lerp(
	player.velocity.x,
	input_LR * move_speed,
	air_control )
