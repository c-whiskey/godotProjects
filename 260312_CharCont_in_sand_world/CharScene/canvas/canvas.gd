extends TextureRect
class_name Canvas

@export var px_scale: int = 3
@onready var canvasPos = position
# THIS IS THE SAAAAAAAAND image...
func _ready() -> void:
	texture = ImageTexture.create_from_image(Image.create(CommonReference.viewport_width,
														  CommonReference.viewport_height, false, Image.FORMAT_RGB8))
	set_size(Vector2(CommonReference.viewport_width,CommonReference.viewport_height))

	
	pass # 196 should be 192

func _process(delta):
	pass

func repaint() -> void:
	#var width: int = CommonReference.main.sim.get::_width()
	#var height: int = CommonReference.main.sim.get_height()
	var dim = 64

	var width = CommonReference.viewport_width
	var height = CommonReference.viewport_height
	
	var xMin = int(%Camera2D.get_screen_center_position().round().x - width / 2)
	var xMax = int(%Camera2D.get_screen_center_position().round().x + width / 2)
	var yMin = int(%Camera2D.get_screen_center_position().round().y - height / 2)
	var yMax = int(%Camera2D.get_screen_center_position().round().y + height / 2)
	
	var xDim = xMax - xMin
	var yDim = yMax - yMin
	#prints(%Camera2D.get_screen_center_position() , "     ", %character.position)
	#print(%Camera2D.global_position)

	var data: PackedByteArray = CommonReference.main.sim.get_colour_image(xMin,yMin,xMax,yMax)
	
	# print the Pixels
#	for node in $"../../../../Node2D".get_children():
#		var targetA = node.global_position.round() - Vector2(xMin,yMin)
#		var index = (targetA.y * xDim + targetA.x)*3 # THIS VALUE NEVER CHANGES,
#		# fucking solved it.
#		# rasterize all 'godot world' objects and put them in the image.
#		# just need to modify the data... don't actually need to place them in the world. 
#		if index >= data.size():
#			continue
#		if index < 0:
#			continue
#		data[index] = 255
#		data[index + 1] = 0 
#		data[index + 2] = 255
	
	texture.set_image(Image.create_from_data(xDim,yDim, false, Image.FORMAT_RGB8, data))
