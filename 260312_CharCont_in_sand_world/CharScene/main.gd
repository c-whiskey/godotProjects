extends Node2D

class_name Main
# Initializes the SandSimulation object and acts as an interface for other nodes to 
# interact with said object. Also runs the main processing of the simulation.
var sim: SandSimulation
var active: bool = false
var chunk_size  : int = 16

func _ready() -> void:
	sim = SandSimulation.new()
	await get_tree().get_root().ready
	active = true
	#sim.step()
	$character/Camera2D/CanvasLayer/Canvas.repaint()
	#$character/Canvas.repaint()
	var image : Image = $Sprite2D.texture.get_image()
	image.resize(image.get_width(),image.get_width())
	image.resize(64,64)
	print("IMAGE FORMAT " , str(image.get_format())) # .get_format() get_data()
	image.convert(4)
	print("IMAGE FORMAT " , str(image.get_format())) # .get_format() get_data()
	#print(image.get_data())
	image.get_width()
	image.get_height()
	sim.make_pixels_from_image(image.get_data(), 64, 64)

func _process(delta):#(delta):
	pass

#Made with Godot 
func _on_timer_timeout():
	var timeStart = Time.get_unix_time_from_system()

	var xMin = max(0,$character.position.x-96-64)
	var yMin = max(0,$character.position.y-64-64)
	
	var xMax = min($character.position.x+96+64, 512)
	var yMax = min($character.position.y+64+64, 512)
	sim.set_active_simulation_area(xMin,yMin,xMax,yMax)
	sim.step()
	#$character/Camera2D/CanvasLayer/Canvas.B_paint()
	$character/Camera2D/CanvasLayer/Canvas.repaint()
	
	var timeStop = Time.get_unix_time_from_system() - timeStart
	#print("Step calc duration ", timeStop)
	#$Timer.wait_time = 1
	$Timer.start() 
	
	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Place your custom save logic or confirmation dialog here
		print("Quit requested. Performing custom actions.")
		#sim = null
