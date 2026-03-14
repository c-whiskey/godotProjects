extends Node

# Why is this script necessary?
# Because our sand simulation does not possess any kind of
# collision shape or collion box
# So if we want a character to interact with the terrain
# then we need to describe how to resolve collisions

# I guess for that I'll need a simulation reference... boo
var sandSimRef : SandSimulation 

@export var player :CharacterBody2D
@export var moveController :MovementController


func _ready() -> void:
	await get_tree().get_root().ready
	sandSimRef = CommonReference.get_sand_world_reference()

func _physics_process(_delta: float) -> void:
	update_intersecting_text()
	push_char_from_terrain()

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


func push_char_from_terrain():
	
	var topLeft = player.position-$"../../CollisionShape2D".shape.get_rect().size/2
	var botRight = $"../../CollisionShape2D".shape.get_rect().size/2 + player.position
	var elementData = sandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	var pushout = Vector2.ZERO
	#account for 
	var playPos = Vector2(dimX/2, dimY/2)
	for y in dimY:
		for x in dimX:
			var index = (y*dimX+x)
			if index >= elementData.size():
				continue
			if(elementData[index] != 0):
				#var push = playPos - Vector2(x,y)
				var dir = (playPos - Vector2(x,y))#.normalized()
				pushout += dir
				#prints("push: ",Vector2(x,y) ,"-",playPos , " = " , (Vector2(x,y)-playPos) )
				pass

	if pushout.length() <= 0:
		return false
	var max = -2.0
	var vec = Vector2.ZERO

	var Line2d = $"../../Line2D"
	Line2d.clear_points()
	Line2d.add_point(Vector2.ZERO)
	Line2d.add_point(pushout * 5)
	
	if pushout.dot(Vector2.RIGHT) > max:
		max = pushout.dot(Vector2.RIGHT) 
		vec = Vector2.RIGHT
		Line2d.default_color = Color.RED
	if pushout.dot(Vector2.LEFT) > max:
		max = pushout.dot(Vector2.LEFT) 
		vec = Vector2.LEFT
		Line2d.default_color = Color.LIME
	if pushout.dot(Vector2.UP) > max:
		max = pushout.dot(Vector2.UP) 
		vec = Vector2.UP
		Line2d.default_color = Color.PURPLE
	if pushout.dot(Vector2.DOWN) > max: 
		max = pushout.dot(Vector2.DOWN) 
		vec = Vector2.DOWN
		Line2d.default_color = Color.GOLD
	pushout = vec.round()
	prints("pushout",pushout, " - MAX: ", max)
	#$Line2D.clear_points()
	
	#player.velocity += pushout * 100

	var test_dirs = []
	test_dirs = [Vector2(0, sign(pushout.y)), Vector2(sign(pushout.x), 0)]

	Line2d.add_point(Vector2.ZERO)
	Line2d.add_point(pushout * 5)
	
	return true
