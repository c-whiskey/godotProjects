@tool
extends EditorPlugin

var button: Button

func _enter_tree():
	button = Button.new()
	button.text = "Run Mixamo Conversion"
	button.pressed.connect(_on_button_pressed)
	add_control_to_container(CONTAINER_TOOLBAR, button) # <-- top toolbar

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	button.queue_free()

func _on_button_pressed():
	var converter := preload("res://addons/mixamo_converter/mixamo_converter.gd").new()
	converter._run()
