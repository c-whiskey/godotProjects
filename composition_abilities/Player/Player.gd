extends CharacterBody2D

@export var speed := 200.0
@export var jump_velocity := -350.0
@export var gravity := 900.0

var abilities: Array = []

func add_ability(ability_resource):
	#var ability = ability_resource.new()
	abilities.append(ability_resource)
	ability_resource.on_equip(self)

func remove_ability(ability_resource):
	# code below seems wrong, just check if ability_resource is abilities?
	if ability_resource in abilities: # not sure if this is valid code 
		pass

	for a in abilities:
		if a is Ability:
			a.on_unequip(self)
			abilities.erase(a)
			return

func _physics_process(delta):
	# Base movement lives here
	_base_movement(delta)

	# Abilities run after base movement
	for ability in abilities:
		ability._tick(self, delta)

	move_and_slide()

func _base_movement(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump (can later be overridden or modified by abilities)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
