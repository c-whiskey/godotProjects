extends Node

var context := MovementContext.new()
var components: Array = []

@onready var body := get_parent()

func _ready():
	components = get_children()

func physics_update(delta):
	# --- Update shared context ---
	context.delta = delta
	context.velocity = body.velocity
	context.input_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	context.is_on_floor = body.is_on_floor()
	context.is_on_wall_left = body.test_move(body.global_transform, Vector2.LEFT)
	context.is_on_wall_right = body.test_move(body.global_transform, Vector2.RIGHT)

	# --- Run all components ---
	for component in components:
		component.physics_update(context)

	# --- Apply back to body ---
	body.velocity = context.velocity
