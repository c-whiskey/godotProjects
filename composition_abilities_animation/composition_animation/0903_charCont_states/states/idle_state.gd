extends Node

@onready var moveController :MovementController = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()


func check_input():
	if !Input.is_anything_pressed():
		moveController.currentAction = moveController.playerAction.IDLE
