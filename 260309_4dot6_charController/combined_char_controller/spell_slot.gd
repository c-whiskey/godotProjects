extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

func physics_update(delta : float):
# intention is for spell slot to call a child scene for the active spell
# eg, heal flask, speed flask, etc etc
# maybe I can  just leave it as heal for now...

	# should be consume
	if !player.is_on_floor():
		return
	
	#if Input.is_action_just_pressed("spell_slot"):
	if (Input.is_action_just_pressed("spell_slot") ):# && can_ground_jump:
		moveController.request_action_change(moveController.playerAction.SPELL_ABILITY)
		# this would have some locking until spell slot is complete
		
	if moveController.currentAction != moveController.playerAction.SPELL_ABILITY:
		return
	if moveController.animationPlayer.current_animation != "universialAnimations_2/Consume":
		moveController.lock_action()
		moveController.animationPlayer.play("universialAnimations_2/Consume",0.2)
