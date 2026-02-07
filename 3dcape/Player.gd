extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 0

var target_velocity = Vector3.ZERO

var speedF = 0.1
func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_key_pressed(KEY_A):
		direction.x -= speedF
	if Input.is_key_pressed(KEY_D):
		direction.x += speedF
	if Input.is_key_pressed(KEY_W):
		direction.z -= speedF
	if Input.is_key_pressed(KEY_S):
		direction.z += speedF

		# Setting the basis property will affect the rotation of the node.
		#$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	look_at(target_velocity)
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
