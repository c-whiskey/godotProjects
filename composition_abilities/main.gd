extends Node2D


func _ready():
	var double_jump_res = preload("res://Abilities/double_jump.tres")
	$Player.add_ability(double_jump_res)

	var aHover = preload("res://Abilities/Hover.tres")
	$Player.add_ability(aHover)
