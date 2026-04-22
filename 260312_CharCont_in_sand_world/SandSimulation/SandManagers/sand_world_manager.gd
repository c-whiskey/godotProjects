extends SandWorldManager

@onready var player := $"../Player"
func _ready() -> void:
	set_world_gen($"../WorldGenerator".get_path())
	set_sand_simulator(get_node("../../SandSimulation").get_path())
	player = get_node("../../Combined_char")
	
func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_9):
		$Timer.start()

func _on_timer_timeout() -> void:
	second_update_world_clusters(player.position)
	#delete_old_clusters()
	#draw_clusters()
	pass # Replace with function body.

var activeTextureRect : Array[TextureRect]

func delete_old_clusters():
	for im in activeTextureRect:
		#im.queue_free()
		pass

func draw_clusters():
	#if Input.is_key_label_pressed(KEY_G):
	var x : Array = temp_get_sand_clusters()
	
	for aSand in x:
		var sand : SandCluster = aSand
		var colData = sand.get_color_data();

		#Image.create_from_data(width: int, height: int, use_mipmaps: bool, format: Format, data: PackedByteArray) static
		var im := Image.create_from_data(512, 512, false, Image.FORMAT_RGBA8, colData)
		
		#text.texture = ImageTexture.create_from_image(im)
		#text.size = im.get_size()
		var text := TextureRect.new()
		text.position = sand.get_position()
		#prints("placing img at ", sand.get_position())
		text.texture = ImageTexture.create_from_image(im)
		text.size = im.get_size()
		add_child(text)
		activeTextureRect.append(text)
		queue_redraw()
	pass
