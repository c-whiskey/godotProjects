extends Node

@export var player :CharacterBody2D #= get_parent().get_parent()
@export var moveController :MovementController# = get_parent()

@export var gravity: float = 2000
@export var max_fall_speed: float = 1600
@export var fall_multiplier: float = 1.5

func physics_update(delta : float):
	if player.is_on_floor(): # or the player is submerged #or player is jumping...
		return

	if player.velocity.y > 0:
		moveController.request_action_change(moveController.playerAction.FALLING) # not sure if this is quite right.. what if we are going down a slope?
		player.velocity.y += gravity * fall_multiplier * delta
	else:
		player.velocity.y += gravity * delta

	player.velocity.y = min(player.velocity.y, max_fall_speed)

	if moveController.currentAction == moveController.playerAction.FALLING:
		if moveController.animationPlayer.current_animation != "universialAnimations/Jump":
			moveController.animationPlayer.play("universialAnimations/Jump",0.2)
