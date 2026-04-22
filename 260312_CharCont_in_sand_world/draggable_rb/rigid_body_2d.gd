extends RigidBody2D

var mouse_hover = true


func _ready() -> void:
	$Polygon2D.modulate = Color(randf_range(0.4,1.0) , randf_range(0.4,1.0) , randf_range(0.4,1.0))

func _physics_process(delta: float) -> void:
	#apply_central_force(get_global_mouse_position())
	#$CharacterBody2D.move_and_slide()
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_hover:
			pass#position = get_global_mouse_position()



func _on_mouse_entered() -> void:
	mouse_hover = true
	$Timer.stop()
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	#$Timer.start(3)
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	mouse_hover = false
	pass # Replace with function body.
