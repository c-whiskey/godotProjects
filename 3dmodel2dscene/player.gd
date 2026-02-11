extends CharacterBody2D

@onready var playerAnim := $SubViewportContainer/SubViewport/Running/AnimationPlayer2
@onready var player := $SubViewportContainer/SubViewport/Running

func _ready() -> void:
	#playerAnim.play("runningAnimation/mixamo_com")
	playerAnim.play("lib__lib__Thriller Part 3/mixamo_com")
	#lib__lib__Thriller Part 3
	pass

var speed = 3

func _process(delta: float) -> void:
	player.rotate_y(PI * delta * delta)
	
	
	if Input.is_key_pressed(KEY_A):
		#player.rotate_y(PI * delta * delta)
		player.look_at(Vector3.RIGHT)
		position.x -= speed
		pass
	if Input.is_key_pressed(KEY_D):
		player.look_at(Vector3.LEFT)
		position.x += speed
		pass
	if Input.is_key_pressed(KEY_W):
		position.y -= speed
		pass
	if Input.is_key_pressed(KEY_S):
		position.y += speed
		pass
