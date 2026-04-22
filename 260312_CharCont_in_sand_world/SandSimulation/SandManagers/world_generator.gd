extends WorldGenerator



func _ready() -> void:
	set_tile_extractor($"../TileExtractor".get_path())
	
#
#
#func _process(delta: float) -> void:
#
	#if Input.is_key_label_pressed(KEY_G):
		#var x : Array = get_clusters(get_global_mouse_position().x, get_global_mouse_position().y)
		#for aSand in x:
			#var sand : SandCluster = aSand
			#var colData = sand.get_color_data();
#
			##Image.create_from_data(width: int, height: int, use_mipmaps: bool, format: Format, data: PackedByteArray) static
			#var im := Image.create_from_data(512, 512, false, Image.FORMAT_RGBA8, colData)
			#
			##text.texture = ImageTexture.create_from_image(im)
			##text.size = im.get_size()
			#var text := TextureRect.new()
			#text.position = sand.get_position()
			#prints("placing img at ", sand.get_position())
			#text.texture = ImageTexture.create_from_image(im)
			#text.size = im.get_size()
			#add_child(text)
			#queue_redraw()
