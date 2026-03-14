extends Node

# Put this script in Project Settings → Autoload

# I want this https://deadcells.fandom.com/wiki/Controls

func _ready():
	setup_input_map()

func setup_input_map():
	# --- Movement ---
	add_action_key("move_left", KEY_A)
	add_action_key("move_left", KEY_LEFT)

	add_action_key("move_right", KEY_D)
	add_action_key("move_right", KEY_RIGHT)

	add_action_key("move_up", KEY_W)
	add_action_key("move_up", KEY_UP)

	add_action_key("move_down", KEY_S)
	add_action_key("move_down", KEY_DOWN)

	# Gamepad Left Stick
	add_action_joy_axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	add_action_joy_axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	add_action_joy_axis("move_up", JOY_AXIS_LEFT_Y, -1.0)
	add_action_joy_axis("move_down", JOY_AXIS_LEFT_Y, 1.0)

	# --- Actions ---
	add_action_key("jump", KEY_SPACE)
	#add_action_mouse_button("jump", MOUSE_BUTTON_LEFT)
	add_action_joy_button("jump", JOY_BUTTON_A)

	add_action_key("sprint", KEY_SHIFT)
	add_action_joy_button("sprint", JOY_BUTTON_LEFT_SHOULDER)

	add_action_key("dash", KEY_SHIFT)
#	add_action_mouse_button("dash", MOUSE_BUTTON_RIGHT)
	add_action_joy_button("dash", JOY_BUTTON_B)

	add_action_key("inventory", KEY_TAB)
	add_action_joy_button("inventory", JOY_BUTTON_Y)


	add_action_mouse_button("light_attack", MOUSE_BUTTON_LEFT)

# ------------------------
# Helper Functions
# ------------------------

func ensure_action(action_name: String):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

func add_action_key(action_name: String, keycode: Key):
	ensure_action(action_name)

	var event := InputEventKey.new()
	event.keycode = keycode
	InputMap.action_add_event(action_name, event)

func add_action_mouse_button(action_name: String, button_index: MouseButton):
	ensure_action(action_name)

	var event := InputEventMouseButton.new()
	event.button_index = button_index
	InputMap.action_add_event(action_name, event)

func add_action_joy_button(action_name: String, button_index: JoyButton):
	ensure_action(action_name)

	var event := InputEventJoypadButton.new()
	event.button_index = button_index
	InputMap.action_add_event(action_name, event)

func add_action_joy_axis(action_name: String, axis: JoyAxis, axis_value: float):
	ensure_action(action_name)

	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = axis_value
	InputMap.action_add_event(action_name, event)

#
#
#extends Node
#
##put me in project autoloads
#func _ready():
#	setup_input_map()
#
#func setup_input_map():
#	add_action_key("move_left", KEY_A)
#	add_action_key("move_left", KEY_LEFT)
#
#	add_action_key("move_right", KEY_D)
#	add_action_key("move_right", KEY_RIGHT)
#
#	add_action_key("move_up", KEY_W)
#	add_action_key("move_up", KEY_UP)
#
#	add_action_key("move_down", KEY_S)
#	add_action_key("move_down", KEY_DOWN)
#
#	add_action_key("jump", KEY_SPACE)
#	add_action_key("sprint", KEY_SHIFT)
#	add_action_key("dash", KEY_SHIFT)
#	#add_action_key("run", KEY_SHIFT)
#	add_action_key("tab", KEY_TAB)
#
#func add_action_key(action_name: String, keycode: Key):
#	if not InputMap.has_action(action_name):
#		InputMap.add_action(action_name)
#
#	var event := InputEventKey.new()
#	event.keycode = keycode
#	InputMap.action_add_event(action_name, event)
