extends CharacterBody2D

@onready var movement_controller = $MovementController

func _physics_process(delta):
	movement_controller.physics_update(delta)
	move_and_slide()
