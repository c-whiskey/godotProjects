# WalkBehavior.gd
extends Node

@export var speed: float = 200.0

func apply_behavior(delta, rbRef:CharacterBody2D):
	var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	rbRef.velocity.x = move_toward(rbRef.velocity.x, input_dir * speed, 200)
