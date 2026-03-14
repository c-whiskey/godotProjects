# JumpBehavior.gd
extends Node

@export var jump_force: float = 400.0
@export var jump_coyote_time: float = 1.0

var coyote_timer = 100.0

func apply_behavior(delta, rbRef:CharacterBody2D):
	var character = get_parent() as CharacterBody2D

	if character.is_on_floor():
		coyote_timer = jump_coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		rbRef.velocity.y = -jump_force
		coyote_timer = 10.0
	
