extends Node
class_name MovementController

@onready var player : CharacterBody2D = get_parent()

enum playerAction {IDLE,
					MOVING,
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
