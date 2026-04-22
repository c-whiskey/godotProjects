extends TileExtractor
var horiz : Array
var vert

func _ready() -> void:
	find_tiles(texture.get_image())
	
	#horiz  = get_horiztonal_tiles()
	#vert = get_vertical_tiles()
#
#var qPressed = false
#
#func _physics_process(delta: float) -> void:
	#if Input.is_key_label_pressed(KEY_W):
		#qPressed = false;
	#if Input.is_key_label_pressed(KEY_Q):
		#if qPressed: 
			#return
#
		#qPressed = true
		#
		#var text := TextureRect.new()
		#text.position = get_global_mouse_position()
		#
		##$TextureRect.texture.set_image(horiz.pick_random())
		#var im : Image = horiz.pick_random()
		#text.texture = ImageTexture.create_from_image(im)
		#text.size = im.get_size()
		#add_child(text)
		#queue_redraw()
#
	#if Input.is_key_label_pressed(KEY_P):
		#print(horiz.size())
		#print(vert.size())
		##$TextureRect.texture.set_image(horiz.pick_random())
		#var im : Image = horiz.pick_random()
		#$TextureRect.texture = ImageTexture.create_from_image(im)
		#$TextureRect.size = im.get_size()
		#queue_redraw()
		#
		##$TextureRect.texture.set_image(Image.create_from_data(xDim,yDim, false, Image.FORMAT_RGBA8, data))
	#if Input.is_key_label_pressed(KEY_K):
		#var im : Image = vert.pick_random()
		#$TextureRect.texture = ImageTexture.create_from_image(im)
		#$TextureRect.size = im.get_size()
		#queue_redraw()
		#
	#if Input.is_key_label_pressed(KEY_O):
		#var im : Image = horiz.pick_random()
		#print(im.get_size())
		#pass
		#
