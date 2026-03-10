extends Node


@export var player :CharacterBody2D
@export var moveController :MovementController


@export var jump_force: float = 700
@export var jump_cut_multiplier: float = 0.5

@export var coyote_time: float = 0.12
var timer: float = 0.0


var can_ground_jump = false
func physics_update(delta : float):

	var is_on_floor = player.is_on_floor()

	if (Input.is_action_just_pressed("jump") ):# && can_ground_jump:
		player.velocity.y = -jump_force
		moveController.currentAction = moveController.playerAction.JUMP_ABILITY

		if moveController.animationPlayer.current_animation != "universialAnimations_2/NinjaJump_Idle":
			moveController.animationPlayer.play("universialAnimations_2/NinjaJump_Idle",0.05)

	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= jump_cut_multiplier

#TODO. Jump Bufer, coyote time, limit to 1 jump, reset on hitting ground.
#TODO. AIR buffer.. I think maybe keep it in run, rename it to movement
# and enable air buffer on jump and fall


# Consider override actions too?
# eg, jump override. 
# maybe in the defaults, check if we have a jump override object. if so, just early return
# on the default jump


# game title. Seeker
# colour your seeker. 
# that way I don't have to worry about a model... I can just use the mixamo one..
# but I do have to worry about armour ??
# I could just use the fantasy armour pack?
