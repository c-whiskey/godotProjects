extends RigidBody2D


var mouse_hover = true

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_hover:
			#position = get_global_mouse_position()
			apply_central_force((get_global_mouse_position() - position) * 5)
			
