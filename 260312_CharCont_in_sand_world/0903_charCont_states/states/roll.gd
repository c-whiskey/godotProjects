extends Node

@onready var moveController :MovementControllerDupe = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()

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
		player.velocity = roll_direction * roll_speed

		if roll_timer <= 0:
			is_rolling = false
			moveController.unlock_action()
		return

	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:
		var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		roll_direction = Vector2(input_dir, 0).normalized()
		moveController.request_action_change(moveController.playerAction.MOVE_ABILITY)
		
		if roll_direction == Vector2.ZERO:
			roll_direction = Vector2(sign(player.velocity.x), 0)

		is_rolling = true
		roll_timer = roll_time
		#lock state
		moveController.lock_action()
		cooldown_timer = roll_cooldown
