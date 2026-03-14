extends Node

const BUTTON_NAMES := {
	JOY_BUTTON_A: "A",
	JOY_BUTTON_B: "B",
	JOY_BUTTON_X: "X",
	JOY_BUTTON_Y: "Y",
	JOY_BUTTON_BACK: "Back",
	JOY_BUTTON_GUIDE: "Guide",
	JOY_BUTTON_START: "Start",
	JOY_BUTTON_LEFT_STICK: "Left Stick Press",
	JOY_BUTTON_RIGHT_STICK: "Right Stick Press",
	JOY_BUTTON_LEFT_SHOULDER: "LB",
	JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JOY_BUTTON_DPAD_UP: "DPad Up",
	JOY_BUTTON_DPAD_DOWN: "DPad Down",
	JOY_BUTTON_DPAD_LEFT: "DPad Left",
	JOY_BUTTON_DPAD_RIGHT: "DPad Right"
}

const AXIS_NAMES := {
	JOY_AXIS_LEFT_X: "Left Stick X",
	JOY_AXIS_LEFT_Y: "Left Stick Y",
	JOY_AXIS_RIGHT_X: "Right Stick X",
	JOY_AXIS_RIGHT_Y: "Right Stick Y",
	JOY_AXIS_TRIGGER_LEFT: "Left Trigger",
	JOY_AXIS_TRIGGER_RIGHT: "Right Trigger"
}


func _ready():
	print("Connected controllers:")
	for device in Input.get_connected_joypads():
		print("Device:", device, "Name:", Input.get_joy_name(device))


func _input(event):

	if event is InputEventJoypadButton:
		var name = BUTTON_NAMES.get(event.button_index, "Unknown Button")
		print(
			"[BUTTON]",
			name,
			"device:", event.device,
			"pressed:", event.pressed
		)

	elif event is InputEventJoypadMotion:
		var name = AXIS_NAMES.get(event.axis, "Unknown Axis")
		print(
			"[AXIS]",
			name,
			"value:", event.axis_value
		)
