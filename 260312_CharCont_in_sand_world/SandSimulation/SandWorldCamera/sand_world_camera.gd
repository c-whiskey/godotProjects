extends Camera2D

@export var SandSimRef : SandSimulation
@onready var canvas := %Canvas

#@onready var SandSimRef : SandSimulation = SandWorldRef.sand_simulation

func _process(_delta: float) -> void:
	repaint_canvas()

func repaint_canvas():
	var width = CommonReference.viewport_width
	var height = CommonReference.viewport_height

	var xMin = int(get_screen_center_position().round().x - width / 2.0)
	var xMax = int(get_screen_center_position().round().x + width / 2.0)
	var yMin = int(get_screen_center_position().round().y - height / 2.0)
	var yMax = int(get_screen_center_position().round().y + height / 2.0)
	
	var xDim = xMax - xMin
	var yDim = yMax - yMin

	#var data: PackedByteArray = CommonReference.main.sim.get_colour_image(xMin,yMin,xMax,yMax)
	var data: PackedByteArray = SandSimRef.get_colour_image(xMin,yMin,xMax,yMax)
	
	canvas.texture.set_image(Image.create_from_data(xDim,yDim, false, Image.FORMAT_RGB8, data))
	pass

func _ready() -> void:
	await get_tree().get_root().ready

	var initImage = Image.create(CommonReference.viewport_width,CommonReference.viewport_height, false, Image.FORMAT_RGB8)
	canvas.texture = ImageTexture.create_from_image(initImage)
	canvas.set_size(Vector2(CommonReference.viewport_width,CommonReference.viewport_height))
	pass
