extends Node

@onready var moveController :MovementController = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()

@export var gravity: float = 2000
@export var max_fall_speed: float = 1600
@export var fall_multiplier: float = 1.5

func physics_update(delta : float):
	if player.is_on_floor():
		return

	if player.velocity.y > 0:
		player.velocity.y += gravity * fall_multiplier * delta
	else:
		player.velocity.y += gravity * delta

	player.velocity.y = min(player.velocity.y, max_fall_speed)


# coyote time
# input buffer
