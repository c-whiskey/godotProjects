extends Node2D
class_name Main
var sim: SandSimulation
var active: bool = false
var chunk_size  : int = 16


func _ready() -> void:
	pass
	#var image : Image = $Sprite2D.texture.get_image()
	#image.resize(image.get_width(),image.get_width())
	#image.resize(64,64)
	#print("IMAGE FORMAT " , str(image.get_format())) # .get_format() get_data()
	#image.convert(4)
	#print("IMAGE FORMAT " , str(image.get_format())) # .get_format() get_data()
	##print(image.get_data())
	#image.get_width()
	#image.get_height()
	#sim.make_pixels_from_image(image.get_data(), 64, 64)


#Made with Godot 
func _on_timer_timeout():
	var timeStart = Time.get_unix_time_from_system()
	var timeStop = Time.get_unix_time_from_system() - timeStart
	$Timer.start() 

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Quit requested. Performing custom actions.")
