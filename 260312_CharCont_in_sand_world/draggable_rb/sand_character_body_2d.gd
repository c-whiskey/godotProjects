extends SandCharacterBody2D

@export var gravity: float = 50.0
@export var speed: float = 100.0
@export var max_fall_speed: float = 160
@export var fall_multiplier: float = 100
@export var jump_force = 100

func proc_gravity(delta : float):
	if is_on_sand_floor(): # or the player is submerged #or player is jumping... have a state for it...
		return
	if is_on_floor():
		return
		#velocity.y += gravity
	velocity.y += 100
	#velocity.y = min(velocity.y, max_fall_speed)

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1

	direction = direction.normalized()
	velocity = direction * speed #* jumpStr
	#proc_gravity(delta)

	sand_move_and_slide()
	#move_and_slide()
	
	$stateText.text = "floor: " + str(is_on_sand_floor() || is_on_floor())
	
	#$RichTextLabel.text = str(velocity)  
	$RichTextLabel.text = str(position)  
