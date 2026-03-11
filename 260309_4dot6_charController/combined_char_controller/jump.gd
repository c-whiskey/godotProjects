extends Node

@export var player :CharacterBody2D
@export var moveController :MovementController

@export var jump_force: float = 700
@export var jump_cut_multiplier: float = 0.5

@export var coyote_time: float = 0.12
var coyote_timer: float = 0.0

@export var jump_buffer_time: float = 0.12
var jump_buffer_timer: float = 0.0

func physics_update(delta : float):
	update_coyote_timer(delta)
	update_buffer_timer(delta)

	if jump_buffer_timer > 0 and coyote_timer > 0:
		moveController.request_action_change(moveController.playerAction.JUMP_ABILITY)
		if moveController.currentAction != moveController.playerAction.JUMP_ABILITY:
			return
			
		player.velocity.y = -jump_force
		# consume timers so jump can't trigger again
		jump_buffer_timer = 0
		coyote_timer = 0

		if moveController.animationPlayer.current_animation != "universialAnimations_2/NinjaJump_Idle":
			moveController.animationPlayer.play("universialAnimations_2/NinjaJump_Idle", 0.05)

	# --- Jump cut (variable height) ---
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= jump_cut_multiplier

func update_coyote_timer(delta : float):
	if player.is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

func update_buffer_timer(delta : float):
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta


# Consider override actions too?
# eg, jump override. 
# maybe in the defaults, check if we have a jump override object. if so, just early return
# on the default jump

# game title. Seeker
# colour your seeker. 
# that way I don't have to worry about a model... I can just use the mixamo one..
# but I do have to worry about armour ??
# I could just use the fantasy armour pack?

## YOUR GEAR IS YOUR CLASS.
# thief, archer, mage, warrior
