extends Node
class_name MovementController

@onready var player : CharacterBody2D = get_parent()
@onready var animationPlayer :AnimationPlayer = $"../SubViewportContainer/SubViewport/Running/AnimationPlayer"

enum playerAction { IDLE,
					MOVING,
					FALLING,
					JUMP_ABILITY,
					MOVE_ABILITY,
					SPELL_ABILITY,
					LIGHT_ATTACK,
					HEAVY_ATTACK
					}

enum playerState {ON_GROUND, IN_AIR, SUBMERGED}

var currentAction := playerAction.IDLE
var currentState := playerState.ON_GROUND

var action_locked = false
var state_locked = false

func reset_action():
	currentAction = playerAction.IDLE

func _physics_process(delta: float) -> void:
	$"../RichTextLabel".text = playerAction.keys()[currentAction]
	var defaultMovements = $Defaults.get_children()
	for movement in defaultMovements:
		if movement.has_method("physics_update"):
			movement.physics_update(delta)
		# I think defaults will just be basic left right movement
		# and jumping..
		# everything else is additional?
		# honestly it shouldn't matter, 
		#because your state based movement should cover things appropriately.

	var overrideMovement = $Overrides.get_children()
	for movement in overrideMovement:
		if movement.has_method("physics_update"):
			movement.physics_update(delta)

	var components = get_children()
	for comp in components:
		if comp.has_method("check_input"):
			comp.check_input()

		if comp.has_method("physics_update"):
			comp.physics_update(delta)
			
	player.move_and_slide()
	
	if player.is_on_floor():
		currentState = playerState.ON_GROUND
	else:
		currentState = playerState.IN_AIR
	
	# else we check if we are submerged
	# is on wall ??? 
	pass



func lock_state():
	state_locked = true

func lock_action():
	action_locked = true

func unlock_action():
	action_locked = false

func request_action_change(action : playerAction):
	if action_locked:
		return false
	currentAction = action
	return true
