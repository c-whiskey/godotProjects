extends SandRigidBody2D


var mouse_hover = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_hover:
			#position = get_global_mouse_position()
			apply_central_force((get_global_mouse_position() - position) * 5)
			
