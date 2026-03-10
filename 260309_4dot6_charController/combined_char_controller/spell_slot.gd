extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

func physics_update(delta : float):
	# if has "JumpAbility" in $overrides: return
	if !player.is_on_floor():
		return
	
	if (Input.is_action_pressed("spell_slot") ):# && can_ground_jump:
		moveController.request_action_change(moveController.playerAction.SPELL_ABILITY)
		# this would have some locking until spell slot is complete
		
	if moveController.currentAction != moveController.playerAction.SPELL_ABILITY:
		return
	#moveController.lock_action()
	if moveController.animationPlayer.current_animation != "universialAnimations_2/Consume":
		moveController.animationPlayer.play("universialAnimations_2/Consume",0.2)
		# reaching the point where I need to figure out the locking mechanism 
		# and how that will work with the nested animation player
