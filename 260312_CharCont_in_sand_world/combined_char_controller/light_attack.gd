extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

var combo_step := 0
var combo_requested := false
var max_combo := 3

@onready var animation_player = $AnimationPlayer
var state_machine

func physics_update(delta : float):
	# should be consume
	if !player.is_on_floor(): # figure this out later.
		return

	if (Input.is_action_just_pressed("light_attack") ):# && can_ground_jump:
		moveController.request_action_change(moveController.playerAction.LIGHT_ATTACK)
		# this would have some locking until spell slot is complete
		combo_requested = true
		
	if moveController.currentAction != moveController.playerAction.LIGHT_ATTACK:
		combo_requested = false
		return

	if combo_requested and combo_step < max_combo:
		combo_requested = false
		play_attack(combo_step)
		combo_step += 1
	if combo_step >= max_combo:
		combo_step = 0

func play_attack(step):
	match step:
		0:
			if moveController.animationPlayer.current_animation != "universialAnimations_2/Sword_Regular_A":
				moveController.animationPlayer.play("universialAnimations_2/Sword_Regular_A",0.2)
				moveController.lock_action()
		1:
			if moveController.animationPlayer.current_animation != "universialAnimations_2/Sword_Regular_B":
				moveController.animationPlayer.play("universialAnimations_2/Sword_Regular_B",0.2)
				moveController.lock_action()
		2:
			if moveController.animationPlayer.current_animation != "universialAnimations_2/Sword_Regular_C":
				moveController.animationPlayer.play("universialAnimations_2/Sword_Regular_C",0.2)
				moveController.lock_action()
