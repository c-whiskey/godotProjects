extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

@export var move_speed: float = 350
@export var air_control: float = 0.15

func physics_update(delta : float):
	var input_LR = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	update_facing(input_LR, delta) # I love this. but I suspect it may cause issues.

	if input_LR != 0 && player.is_on_floor(): # and we are on ground...
		moveController.request_action_change(moveController.playerAction.MOVING)
	else:
		pass#moveController.request_action_change(moveController.playerAction.IDLE)

	if moveController.currentAction != moveController.playerAction.MOVING: # early return?
		return

	if moveController.animationPlayer.current_animation != "universialAnimations/Jog_Fwd":
		moveController.animationPlayer.play("universialAnimations/Jog_Fwd",0.2)

	if player.is_on_floor():
		player.velocity.x = input_LR * move_speed
	else: # air control ... # move this to gravity.. TODO
		player.velocity.x = lerp(
			player.velocity.x,
			input_LR * move_speed,
			air_control )
	# submerged in water??
		pass
	return



@export var left_angle := -90.0
@export var right_angle := 90.0
@export var rotate_speed := 12.0
var target_rotation := 0.0

# i could put this in movementController and then call from each class and give an orientation as arg...
# meaning each action could have its own rotation 
func update_facing(input, delta): 
	if input < 0:
		target_rotation = deg_to_rad(left_angle)
	elif input > 0:
		target_rotation = deg_to_rad(right_angle)
	else:
		target_rotation = 0.0
	var model = $"../../../SubViewportContainer/SubViewport/Running/GeneralSkeleton"
	model.rotation.y = lerp(model.rotation.y, target_rotation, rotate_speed * delta)
