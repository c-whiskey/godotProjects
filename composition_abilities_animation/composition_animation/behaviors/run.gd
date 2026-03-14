# RunBehavior.gd
extends Node

@export var run_multiplier: float = 200

func apply_behavior(delta, rbRef:CharacterBody2D):
	if Input.is_action_pressed("sprint") and rbRef.is_on_floor():
		#rbRef.velocity.x += run_multiplier
		rbRef.velocity.x = move_toward(rbRef.velocity.x, rbRef.velocity.x + run_multiplier * sign(rbRef.velocity.x), 200)
		
