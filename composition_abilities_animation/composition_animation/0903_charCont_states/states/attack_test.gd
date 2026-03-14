extends Node

@onready var moveController :MovementController = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()

@export var attack_speed : float = 1000
@export var attack_time : float = 0.15
@export var attack_cooldown : float = 0.3

var attack_timer : float = 0
var cooldown_timer : float = 0
var is_attacking : bool = false
var attack_direction : Vector2 = Vector2.ZERO

func physics_update(delta : float):
	cooldown_timer -= delta

	if is_attacking:
		attack_timer -= delta
		#player.velocity = attack_direction * attack_speed
		$"../../Sprite/Polygon2D".color = Color.RED

		if attack_timer <= 0:
			is_attacking = false
			moveController.unlock_action()
			moveController.reset_action()
			$"../../Sprite/Polygon2D".color = Color.BLUE
		return

	if Input.is_action_just_pressed("light_attack") and cooldown_timer <= 0:
		var input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		attack_direction = Vector2(input_dir, 0).normalized()
		moveController.request_action_change(moveController.playerAction.LIGHT_ATTACK)
		
		if attack_direction == Vector2.ZERO:
			attack_direction = Vector2(sign(player.velocity.x), 0)

		is_attacking = true
		attack_timer = attack_time
		#lock state
		moveController.lock_action()
		cooldown_timer = attack_cooldown
