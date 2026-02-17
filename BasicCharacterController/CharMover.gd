extends Node3D

var grav = 5 
var jump_time_to_max_height = 1

func _physics_process(delta):
	var grav := _get_gravity()
	var jump_velocity = grav * jump_time_to_max_height
	var max_fall_speed := 200.0

	#tidy_drawCharacterOnImage()

	#_update_coyote_timer(delta)
	#_update_jump_buffer(delta)

	#mover.x = get_horizontal_input()

	_apply_gravity(delta, grav, max_fall_speed)
	_handle_variable_jump()
	_try_jump(jump_velocity)

	_move_and_resolve(delta)

	#_resolve_overlap()

	_update_debug_labels()


# -------------------------------------------------------------------
# Helper Functions
# -------------------------------------------------------------------

func _get_gravity() -> float:
	return (2.0 * jump_pixels) / pow(jump_time_to_max_height, 2)


func _update_coyote_timer(delta):
	if is_on_ground():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)


func _update_jump_buffer(delta):
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)


func _apply_gravity(delta, grav, max_fall_speed):
	if not is_on_ground():
		mover.y += grav * delta
		mover.y = min(mover.y, max_fall_speed)
	else:
		mover.y = 0.0


func _handle_variable_jump():
	if Input.is_action_just_released("ui_accept") and mover.y < 0.0:
		mover.y *= jump_cut_multiplier


func _try_jump(jump_velocity):
	var wants_jump := jump_buffer_timer > 0.0
	var can_jump := is_on_ground() or coyote_timer > 0.0

	if can_jump and wants_jump:
		mover.y = -jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0


func _move_and_resolve(delta):
	var x_steps := int(abs(mover.x))
	var y_steps := int(abs(mover.y * delta))

	# Horizontal movement
	for i in x_steps:
		position.x += sign(mover.x)

		if is_intersecting_terrain():
			var stepped := false

			# Try stepping up 2 pixels
			for up in 2:
				position.y -= 1
				if not is_intersecting_terrain():
					stepped = true
					break

			if not stepped:
				position.y += 2
				position.x -= sign(mover.x)

	# Vertical movement
	for i in y_steps:
		position.y += sign(mover.y)
		if is_intersecting_terrain():
			position.y -= sign(mover.y)
			break


func _resolve_overlap():
	if is_intersecting_terrain():
		push_char_from_terrain()


func _update_debug_labels():
	$Label2.text = str(position)
	$Label.text = str(Engine.get_frames_per_second())
