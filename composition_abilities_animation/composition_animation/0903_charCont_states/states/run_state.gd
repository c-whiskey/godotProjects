extends Node

@onready var moveController :MovementController = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()


@export var move_speed: float = 350
@export var air_control: float = 0.15


func physics_update(delta : float):
#	match moveController.currentAction:
#		moveController.playerAction.IDLE, \
#		moveController.playerAction.MOVING:
#			pass
#		_:
#			return

	if moveController.currentAction != moveController.playerAction.MOVING:
		# play animation on loop
		pass

	var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if input_dir != 0: 
		moveController.request_action_change(moveController.playerAction.MOVING)
		# if true, then change the anim... ?
		# or just check if anim playingh run, if not play run.. ?
	
	# early return if we are not in this action!
	if moveController.currentAction != moveController.playerAction.MOVING:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.15)
		return
		
	if player.is_on_floor():
		player.velocity.x = input_dir * move_speed
	else: # this for when the player is in air.. not sure if I like... 
		player.velocity.x = lerp(
			player.velocity.x,
			input_dir * move_speed,
			air_control )

	if input_dir != 0:
		player.facing_right = input_dir > 0
