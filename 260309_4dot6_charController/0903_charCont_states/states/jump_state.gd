extends Node

@onready var moveController :MovementControllerDupe = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()


@export var jump_force: float = 700
@export var jump_cut_multiplier: float = 0.5

@export var coyote_time: float = 0.12
var timer: float = 0.0


var can_ground_jump = false
func physics_update(delta : float):
	match moveController.currentAction:
		moveController.playerAction.IDLE, \
		moveController.playerAction.MOVING:
			pass
		_:
			return

	var is_on_floor = player.is_on_floor()

	if (Input.is_action_just_pressed("jump") ) && can_ground_jump:
		player.velocity.y = -jump_force
		moveController.currentAction = moveController.playerAction.JUMP_ABILITY

	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= jump_cut_multiplier

#func _physics_process(delta: float) -> void:

	if player.is_on_floor():
		timer = coyote_time
	else:
		timer -= delta
	
	can_ground_jump = timer > 0
	_update_input_buffer(delta)





enum BufferedAction {
	NONE,
	ROLL,
	ATTACK,
	HEAVY_ATTACK,
	JUMP
}

var buffered_action = BufferedAction.NONE
var buffer_timer := 0.0
@export var input_buffer_time := 0.2

# JUMP BUFFER + COYOTE
@export var jump_buffer_time := 0.15

func _update_input_buffer(delta):
	if Input.is_action_just_pressed("jump"):
		buffered_action = BufferedAction.JUMP
		buffer_timer = jump_buffer_time

	if buffer_timer > 0:
		buffer_timer -= delta

	if buffer_timer <= 0:
		buffered_action = BufferedAction.NONE
