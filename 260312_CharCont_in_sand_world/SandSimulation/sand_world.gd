extends Node
class_name SandWorld

var sand_simulation: SandSimulation
var active: bool = false
var chunk_size  : int = 16
@export var playerNode : CharacterBody2D

func _process(_delta: float) -> void:
	prints("DIMENSIONS " , get_viewport().get_visible_rect())
	pass

func _ready() -> void:
	sand_simulation = SandSimulation.new() 
	await get_tree().get_root().ready
	active = true
	#print(get_viewport().get_visible_rect())

func _on_timer_timeout():
	var xMin = max(0,playerNode.position.x-96-64)
	var yMin = max(0,playerNode.position.y-64-64)
	
	var xMax = min(playerNode.position.x+96+64, 512)
	var yMax = min(playerNode.position.y+64+64, 512)
	sand_simulation.set_active_simulation_area(xMin,yMin,xMax,yMax)
	sand_simulation.step()

	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Place your custom save logic or confirmation dialog here
		print("Quit requested. Performing custom actions.")
		#sim = null

func update_simulation_area(player_position : Vector2):
	var xMin = max(0,player_position.x-96-64)
	var yMin = max(0,player_position.y-64-64)
	
	var xMax = min(player_position.x+96+64, 512)
	var yMax = min(player_position.y+64+64, 512)
	pass

func _on_simulation_step_timeout() -> void:
	#sand_simulation.set_active_simulation_area(xMin,yMin,xMax,yMax)
	sand_simulation.step()
	pass # Replace with function body.
