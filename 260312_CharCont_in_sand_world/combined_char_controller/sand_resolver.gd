extends Node

# Why is this script necessary?
# Because our sand simulation does not possess any kind of
# collision shape or collion box
# So if we want a character to interact with the terrain
# then we need to describe how to resolve collisions

# I guess for that I'll need a simulation reference... boo
var SandWorldRef : SandWorld
var sandSimRef : SandSimulation 

@export var player :CharacterBody2D
@export var moveController :MovementController


func _ready() -> void:
	await get_tree().get_root().ready
	SandWorldRef = CommonReference.get_sand_world_reference()
	sandSimRef = SandWorldRef.sand_simulation

func _physics_process(_delta: float) -> void:
	update_intersecting_text()

func is_intersecting_terrain():
	# this is becoming computationally shithouse
	var topLeft = player.position-$"../../CollisionShape2D".shape.get_rect().size/2
	var botRight = $"../../CollisionShape2D".shape.get_rect().size/2 + player.position
	var elementData = sandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	# It would be MUCH faster if I put the below code inside the C++
	# eg... any_terrain_in_bounding_box()
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	for y in dimY: 
		for x in dimX:
			var index = (y*dimX+x)
			if index >= elementData.size():
				continue
			if(elementData[index] != 0):
				return true
	return false

func update_intersecting_text():
	$"../../RichTextLabel2".text = str(is_intersecting_terrain())
	if is_intersecting_terrain():
		$"../../RichTextLabel2".modulate = Color.RED
	else:
		$"../../RichTextLabel2".modulate = Color.BLUE
