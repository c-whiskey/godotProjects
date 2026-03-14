extends TextureRect
class_name Canvas

@export var px_scale: int = 3 # Don't think this gets used. 
@onready var canvasPos = position

#@export var SandSim : SandWorld

# THIS IS THE SAAAAAAAAND image...
# It updates our 'window perspective' into the sand world
# based on the camera position.

func _process(delta: float) -> void:
	var width = CommonReference.viewport_width
	var height = CommonReference.viewport_height

	var xMin = int($"../..".get_screen_center_position().round().x - width / 2.0)
	var xMax = int($"../..".get_screen_center_position().round().x + width / 2.0)
	var yMin = int($"../..".get_screen_center_position().round().y - height / 2.0)
	var yMax = int($"../..".get_screen_center_position().round().y + height / 2.0)
	
	var xDim = xMax - xMin
	var yDim = yMax - yMin

	var data: PackedByteArray = CommonReference.main.sim.get_colour_image(xMin,yMin,xMax,yMax)
	#var data: PackedByteArray = SandSim.get_colour_image(xMin,yMin,xMax,yMax)

	texture.set_image(Image.create_from_data(xDim,yDim, false, Image.FORMAT_RGB8, data))
	pass

func _ready() -> void:
	var initImage = Image.create(CommonReference.viewport_width,CommonReference.viewport_height, false, Image.FORMAT_RGB8)
	texture = ImageTexture.create_from_image(initImage)
	set_size(Vector2(CommonReference.viewport_width,CommonReference.viewport_height))
	pass
