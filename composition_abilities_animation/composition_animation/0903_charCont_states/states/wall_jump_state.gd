extends Node

@onready var moveController :MovementController = get_parent()
@onready var player :CharacterBody2D = get_parent().get_parent()

@export var wall_jump_force: Vector2 = Vector2(450, -650)
@export var jump_cut_multiplier: float = 0.5
@export var wall_slide_speed: float = 250
# now we can put wall slide in here too.

@export var wall_coyote_time: float = 0.15

var wall_timer: float = 0.0
var last_wall_dir: int = 0
var can_wall_jump = false

func physics_update(delta : float):
	var is_on_floor = player.is_on_floor()
	var is_on_wall_left = player.test_move(player.global_transform, Vector2.LEFT)
	var is_on_wall_right = player.test_move(player.global_transform, Vector2.RIGHT)

	# wall slide
	if (is_on_wall_left || is_on_wall_right) and player.velocity.y > wall_slide_speed:
		player.velocity.y = wall_slide_speed

	if Input.is_action_just_pressed("jump") && can_wall_jump:
		var wall_dir = -1 if is_on_wall_left else 1

		if !is_on_floor && can_wall_jump:
			var dir = wall_dir
			player.velocity.x = -dir * wall_jump_force.x
			player.velocity.y = wall_jump_force.y

	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= jump_cut_multiplier

#func _physics_process(delta: float) -> void:#
	#var is_on_wall_left = player.test_move(player.global_transform, Vector2.LEFT)
	#var is_on_wall_right = player.test_move(player.global_transform, Vector2.RIGHT)
	var on_wall = is_on_wall_left or is_on_wall_right
	
	if on_wall and not player.is_on_floor():
		wall_timer = wall_coyote_time
	else:
		wall_timer -= delta

	can_wall_jump = wall_timer > 0
