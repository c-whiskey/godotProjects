extends SandSimulation

@export var playerNode : CharacterBody2D

func _process(_delta: float) -> void:
	#prints("DIMENSIONS " , get_viewport().get_visible_rect())
	pass

#func _physics_process(delta: float) -> void:
	#prints("DIMENSIONS " , get_viewport().get_visible_rect())
	# what we could do in future is change how often we call the step 
	# function by how laggy the game is.
	#Engine.get_frames_per_second() # or just stepping every other frame... 
#	pass

func _on_timer_timeout():
	var xMin = max(0,playerNode.position.x-96-64)
	var yMin = max(0,playerNode.position.y-64-64)
	
	var xMax = min(playerNode.position.x+96+64, 512)
	var yMax = min(playerNode.position.y+64+64, 512)
	set_active_simulation_area(xMin,yMin,xMax,yMax)
	step()

	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Place your custom save logic or confirmation dialog here
		print("Quit requested. Performing custom actions.")
		#sim = null

#func update_simulation_area(player_position : Vector2):
#	var xMin = max(0,player_position.x-96-64)
#	var yMin = max(0,player_position.y-64-64)
#	
#	var xMax = min(player_position.x+96+64, 512)
#	var yMax = min(player_position.y+64+64, 512)
#	pass

#func _on_simulation_step_timeout() -> void:
#	#sand_simulation.set_active_simulation_area(xMin,yMin,xMax,yMax)
#	step()
#	pass # Replace with function body.
