extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

func physics_update(delta : float):
	if !Input.is_anything_pressed():
		moveController.request_action_change(moveController.playerAction.IDLE)

	if moveController.currentAction != moveController.playerAction.IDLE: # early return?
		return
	#player.velocity.x = lerp(player.velocity.x, 0.0, 0.15)

	if moveController.animationPlayer.current_animation != "universialAnimations/Sword_Idle":
		moveController.animationPlayer.play("universialAnimations/Sword_Idle",0.2)
		
		# rotation speed seems a bit off...
		# i guess this is where it would make sense to facing function in movement controller
		# and then call it with a rotation and speed
		
