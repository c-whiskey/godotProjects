extends Node

#put me in project autoloads
func _ready():
	setup_input_map()

func setup_input_map():
	add_action_key("move_left", KEY_A)
	add_action_key("move_left", KEY_LEFT)

	add_action_key("move_right", KEY_D)
	add_action_key("move_right", KEY_RIGHT)

	add_action_key("move_up", KEY_W)
	add_action_key("move_up", KEY_UP)

	add_action_key("move_down", KEY_S)
	add_action_key("move_down", KEY_DOWN)

	add_action_key("jump", KEY_SPACE)
	add_action_key("sprint", KEY_SHIFT)
	add_action_key("tab", KEY_TAB)

func add_action_key(action_name: String, keycode: Key):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	var event := InputEventKey.new()
	event.keycode = keycode
	InputMap.action_add_event(action_name, event)
