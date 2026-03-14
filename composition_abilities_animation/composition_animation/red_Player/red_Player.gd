# Character.gd
extends CharacterBody2D

@export var gravity: float = 1000.0
#var velocity: Vector2 = Vector2.ZERO
var behaviors: Array = []

func _ready():
	# Gather all child behavior scripts
	for child in get_children():
		if "apply_behavior" in child:
			behaviors.append(child)

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	# Let each behavior modify velocity independently
	for behavior in behaviors:
		behavior.apply_behavior(delta, self)

	# Move the character
	#velocity = move_and_slide(velocity, Vector2.UP)
	move_and_slide()
	velocity.x = move_toward(velocity.x, 0, 100) # friction to slow down
