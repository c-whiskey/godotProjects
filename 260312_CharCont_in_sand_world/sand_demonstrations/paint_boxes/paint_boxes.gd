extends Node2D

@export var sandSim : SandSimulation
var element : int = 1

func _physics_process(delta: float) -> void:

	if Input.is_key_pressed(KEY_1):
		element = 1
	if Input.is_key_pressed(KEY_2):
		element = 2
	if Input.is_key_pressed(KEY_3):
		element = 36
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				$CollisionShape2D.position = get_global_mouse_position()
				#var rect : Vector2 = $CollisionShape2D.shape.get_rect().size / 2
				var rect := Vector2(1,1) #= $CollisionShape2D.shape.get_rect().size / 2
				for x in range(rect.x):
					for y in range(rect.y):
						sandSim.paint_cells(int(get_global_mouse_position().x + x),int(get_global_mouse_position().y + y),element)
						
	
	if Input.is_key_pressed(KEY_P):
		#spawnPaintBox

		var image : Image = $Sprite2D.texture.get_image()
		image.resize(image.get_width(),image.get_width())
		image.resize(64,64)
	
		image.convert(4)
		
		$"../SandSimulation".make_pixels_from_image(image.get_data(), 64, 64)
		# I need to make this come in a locaiton. 
		# also... I need function hints
		
