extends Node

#put me in project autoloads
func _ready():
	setup_input_map()
	setup_controller_input_map()
	#print("AAAAH")

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
	add_action_key("dash", KEY_SHIFT)
	add_action_key("tab", KEY_TAB)
	
	add_action_key("kick", KEY_F)
	add_action_key("spell_slot", KEY_E)
	
func setup_controller_input_map():
	# Movement (Left Stick)
	add_action_controller_axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	add_action_controller_axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	add_action_controller_axis("look_up", JOY_AXIS_LEFT_Y, -1.0)
	add_action_controller_axis("look_down", JOY_AXIS_LEFT_Y, 1.0)
	# Face buttons
	add_action_controller_button("jump", JOY_BUTTON_A)
	add_action_controller_button("light_attack", JOY_BUTTON_X)
	add_action_controller_button("movement_ability", JOY_BUTTON_B)
	add_action_controller_button("spell_slot", JOY_BUTTON_B)
	# Shoulder buttons
	add_action_controller_button("sprint", JOY_BUTTON_LEFT_SHOULDER)
	add_action_controller_axis("sprint", JOY_AXIS_TRIGGER_LEFT, 1.0)
	#Dpad 
	add_action_controller_button("pickup", JOY_BUTTON_DPAD_UP)
	add_action_controller_button("select_left", JOY_BUTTON_DPAD_LEFT)
	add_action_controller_button("select_right", JOY_BUTTON_DPAD_RIGHT)
	add_action_controller_button("taunt", JOY_BUTTON_DPAD_DOWN)
	# Menu
	add_action_controller_button("tab", JOY_BUTTON_BACK)

func add_action_key(action_name: String, keycode: Key):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	var event := InputEventKey.new()
	event.keycode = keycode
	InputMap.action_add_event(action_name, event)

func add_action_controller_button(action_name: String, button: JoyButton):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	var event := InputEventJoypadButton.new()
	event.button_index = button

	InputMap.action_add_event(action_name, event)


func add_action_controller_axis(action_name: String, axis: JoyAxis, direction: float):
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)

	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = direction

	InputMap.action_add_event(action_name, event)
