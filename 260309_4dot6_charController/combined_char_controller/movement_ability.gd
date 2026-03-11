extends Node




@export var player :CharacterBody2D
@export var moveController :MovementController

func physics_update2(delta : float):
	# should be consume
	if !player.is_on_floor():
		return
	
	#if Input.is_action_just_pressed("spell_slot"):
	if (Input.is_action_just_pressed("roll") ):# && can_ground_jump:
		moveController.request_action_change(moveController.playerAction.MOVE_ABILITY)
		# this would have some locking until spell slot is complete
	if moveController.currentAction != moveController.playerAction.MOVE_ABILITY:
		return

	if moveController.animationPlayer.current_animation != "universialAnimations/Roll":
		moveController.lock_action()
		moveController.animationPlayer.play("universialAnimations/Roll",0.2)


@export var roll_speed : float = 1000
@export var roll_time : float = 0.15
@export var roll_cooldown : float = 0.3

var roll_timer : float = 0
var cooldown_timer : float = 0
var is_rolling : bool = false
var roll_direction : Vector2 = Vector2.ZERO

func physics_update(delta : float):
	cooldown_timer -= delta

	if is_rolling:
		roll_timer -= delta
		
		#
		var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		roll_direction = Vector2(input_dir, 0).normalized()
		#
		
		player.velocity.x = roll_direction.x * roll_speed

		if roll_timer <= 0:
			is_rolling = false
			moveController.unlock_action()
		return

	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:
		moveController.request_action_change(moveController.playerAction.MOVE_ABILITY)
		if moveController.currentAction != moveController.playerAction.MOVE_ABILITY:
			return
		#var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		#roll_direction = Vector2(input_dir, 0).normalized()
		
		if roll_direction == Vector2.ZERO:
			roll_direction = Vector2(sign(player.velocity.x), 0)

		is_rolling = true
		roll_timer = roll_time
		#lock state
		moveController.lock_action()
		cooldown_timer = roll_cooldown
		
		if moveController.animationPlayer.current_animation != "universialAnimations/Roll":
			moveController.animationPlayer.play("universialAnimations/Roll",0.2,1.5)
			roll_timer = moveController.animationPlayer.get_animation("universialAnimations/Roll").length * (1/1.5) - 0.4
			#roll_timer = moveController.animationPlayer.current_animation.length()
			
