extends Node
class_name SandWorld

var sand_simulation: SandSimulation
var active: bool = false
var chunk_size  : int = 16
@export var playerNode : CharacterBody2D



# I DON"T THINK ANYTHING IS USING THIS SCRIPT
# SCRIPT IS UNUSEEEDD


func _process(_delta: float) -> void:
	prints("DIMENSIONS " , get_viewport().get_visible_rect())
	pass


var sim_world_dim : Vector2i

func _ready() -> void:
	sand_simulation = SandSimulation.new() 
	await get_tree().get_root().readya
	active = true
	sim_world_dim = sand_simulation.get_sim_world_dimensions()
	#print(get_viewport().get_visible_rect())

func _on_timer_timeout():
	var xMin = max(0,playerNode.position.x-96-64)
	var yMin = max(0,playerNode.position.y-64-64)

	var xMax = min(playerNode.position.x+96+64, sim_world_dim.x)
	var yMax = min(playerNode.position.y+64+64, sim_world_dim.y)
	prints(xMin,yMin,xMax,yMax)
	sand_simulation.set_active_simulation_area(xMin,yMin,xMax,yMax)
	sand_simulation.step()

	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Place your custom save logic or confirmation dialog here
		print("Quit requested. Performing custom actions.")
		#sim = null

#func update_simulation_area(player_position : Vector2):
	#var xMin = max(0,player_position.x-96-64)
	#var yMin = max(0,player_position.y-64-64)
	#
	#var xMax = min(player_position.x+96+64, 1024)
	#var yMax = min(player_position.y+64+64, 1024) # this 512 should be the max dimensions of the sim.
	#pass

func _on_simulation_step_timeout() -> void:
	#sand_simulation.set_active_simulation_area(xMin,yMin,xMax,yMax)
	sand_simulation.step()
	pass # Replace with function body.
