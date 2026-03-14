extends RigidBody2D

var speed = 1
var gravity = 2

var mover = Vector2.ZERO
var jump_time_to_descent := 2.0 

@export var SandWorldRef : SandWorld
var SandSimRef : SandSimulation

#@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var jump_height: float #= 48.0        # pixels
@export var jump_time_to_peak: float #= 0.30  # seconds
# Computed per-frame values
const DT := 1.0 / 60.0
@onready var frames := int(round(jump_time_to_peak / DT))
@onready var jump_velocity := (2.0 * jump_height) / float(frames + 1) * -1.0
@onready var gravity_per_frame := -jump_velocity / float(frames) #* -1.0
# Physics timestep (Godot default)

@export var jump_pixels: int
@export var jump_time_to_max_height : float

@onready var jump_init_velocity := (2.0 * jump_pixels)/jump_time_to_max_height
@onready var jump_grav := jump_init_velocity / jump_time_to_max_height


var coyote_time := 0.50        # seconds of forgiveness
var coyote_timer := 0.0        # counts down when leaving ground
var jump_buffer_time := 0.12   # optional but recommended
var jump_buffer_timer := 0.0

var jump_cut_multiplier := 0.45   # 0.0 = instant stop, 1.0 = no short hop


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().get_root().ready
	SandSimRef = SandWorldRef.sand_simulation
	pass # Replace with function body.

func is_intersecting_terrain():
	# this is becoming computationally shithouse
	var topLeft = position-$CollisionShape2D.shape.get_rect().size/2
	var botRight = $CollisionShape2D.shape.get_rect().size/2 + position
	var elementData = SandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	var pushout = Vector2.ZERO
	#account for 
	var playPos = Vector2(dimX/2, dimY/2)
	#prints("topLeft",topLeft," - botRight",botRight, " - dimX", dimX," - dimY", dimY," - playPos",playPos )
	for y in dimY:
		for x in dimX:
			var index = (y*dimX+x)
			if index >= elementData.size():
				continue
			if(elementData[index] != 0):
				return true
	return false

func push_char_from_terrain():
	# this function directly moves the character out of a terrain block
	# based on a ruleset that considers the overlapping terrain
	print(" ")
	print(" ")
	var topLeft = position-$CollisionShape2D.shape.get_rect().size/2
	var botRight = $CollisionShape2D.shape.get_rect().size/2 + position
	var elementData = SandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	var pushout = Vector2.ZERO
	#account for 
	var playPos = Vector2(dimX/2, dimY/2)
	#prints("topLeft",topLeft," - botRight",botRight, " - dimX", dimX," - dimY", dimY," - playPos",playPos )
	for y in dimY:
		for x in dimX:
			var index = (y*dimX+x)
			if index >= elementData.size():
				continue
			if(elementData[index] != 0):
				#var push = (Vector2(x,y)-playPos) * -1
				var push = playPos - Vector2(x,y)
				var dir = (playPos - Vector2(x,y))#.normalized()
				pushout += dir

				
				prints("push: ",Vector2(x,y) ,"-",playPos , " = " , (Vector2(x,y)-playPos) )
				#prints("push", push)
				#pushout += push # were to. where from?
				# it needs to point towards zero zerod
				pass
	#pushout = pushout.normalized() #* 2
	prints("pushout: ",pushout)
	if pushout.length() <= 0:
		return false
	var max = -1.0
	var vec = Vector2.ZERO

	#prints("xyxy",botRight.x , topLeft.x, botRight.y , topLeft.y)
	#prints("dimX,Dimy: ",dimX,dimY)
	#prints("PlayerPos: ",playPos, " - Actual pos", position)
	
	#prints("pushout",pushout, " - pushout.dot(Vector2.RIGHT): ", pushout.dot(Vector2.RIGHT))
	#printss("pushout",pushout, " - pushout.dot(Vector2.LEFT): ", pushout.dot(Vector2.LEFT))
	#prints("pushout",pushout, " - pushout.dot(Vector2.UP): ", pushout.dot(Vector2.UP))
	#prints("pushout",pushout, " - pushout.dot(Vector2.DOWN): ", pushout.dot(Vector2.DOWN))
	$Line2D.clear_points()
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(pushout * 5)
	#$Line2D.add_point(playPos)
	#$Line2D.add_point(pushout * 5)
	
	if pushout.dot(Vector2.RIGHT) > max:
		max = pushout.dot(Vector2.RIGHT) 
		vec = Vector2.RIGHT
		$Line2D.default_color = Color.RED
	if pushout.dot(Vector2.LEFT) > max:
		max = pushout.dot(Vector2.LEFT) 
		vec = Vector2.LEFT
		$Line2D.default_color = Color.LIME
	if pushout.dot(Vector2.UP) > max:
		max = pushout.dot(Vector2.UP) 
		vec = Vector2.UP
		$Line2D.default_color = Color.PURPLE
	if pushout.dot(Vector2.DOWN) > max: 
		max = pushout.dot(Vector2.DOWN) 
		vec = Vector2.DOWN
		$Line2D.default_color = Color.GOLD
	pushout = vec.round()
	prints("pushout",pushout, " - MAX: ", max)
	#$Line2D.clear_points()
	
	position += pushout
	var test_dirs = []
	#if abs(pushout.x) > abs(pushout.y):
	#test_dirs = [Vector2(sign(pushout.x), 0), Vector2(0, sign(pushout.y))]
	#else:
	test_dirs = [Vector2(0, sign(pushout.y)), Vector2(sign(pushout.x), 0)]
	#for dir in test_dirs:
		#position += dir
		#if !is_intersecting_terrain():
			#return false
	#	position -= dir
	
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(pushout * 5)
	
	return true

func tidy_drawCharacterOnImage():
	var topLeft = position-$CollisionShape2D.shape.get_rect().size/2
	var botRight = $CollisionShape2D.shape.get_rect().size/2 + position
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	
	var elementData = SandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	var imData = SandSimRef.get_colour_image(topLeft.x,topLeft.y,botRight.x,botRight.y)
	
	for index in imData.size():
		imData[index] = 255#*index#(imData[index]*2)# % 255
	for index in range(elementData.size()):
		#continue#pass
		#imData[index] = (imData[index]) #% 100
		if elementData[index]:# && rasterRizeCapsule[index]:
			#imData[index] = (imData[index]) #% 100	
			imData[index * 3] = 0 #% 100	
		else:
			elementData[index] = 0
		
	#prints(imData.size(), elementData.size())
	for y in $CollisionShape2D.shape.get_rect().size.y:
		pass
		
	$Sprite2D.texture = ImageTexture.create_from_image(Image.create(dimX,dimY, false, Image.FORMAT_RGB8))
	$Sprite2D.texture.set_image(Image.create_from_data(dimX,dimY, false, Image.FORMAT_RGB8, imData))

func is_ground_below_character():
	var topLeft = position-$CollisionShape2D.shape.get_rect().size/2
	#var topLeft = $CollisionShape2D.shape.get_rect().size/2 + position
	var botRight = $CollisionShape2D.shape.get_rect().size/2 + position #+ Vector2.DOWN * 3
	topLeft.y = botRight.y
	botRight.y += 1
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	
	var elementData = SandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	for x in elementData:
		if x != 0:
			return true #print(x)
	return false

func get_horizontal_input():
	var horizontal = 0.0
	if Input.is_action_pressed("move_left"):
		horizontal = -1
	if Input.is_action_pressed("move_right"):
		horizontal = 1
	return horizontal

func is_on_ground():
	var topLeft = position-$CollisionShape2D.shape.get_rect().size/2
	#var topLeft = $CollisionShape2D.shape.get_rect().size/2 + position
	var botRight = $CollisionShape2D.shape.get_rect().size/2 + position #+ Vector2.DOWN * 3
	topLeft.y = botRight.y
	botRight.y += 1
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	
	var elementData = SandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	for x in elementData:
		if x != 0:
			return true #print(x)
	return false

func resolve_terrain_conflict():
	# this function directly moves the character out of a terrain block
	# based on a ruleset that considers the overlapping terrain

	var topLeft = position-$CollisionShape2D.shape.get_rect().size/2
	var botRight = $CollisionShape2D.shape.get_rect().size/2 + position
	var elementData = SandSimRef.get_simulation_element_data(topLeft.x,topLeft.y,botRight.x,botRight.y)
	var dimX = botRight.x - topLeft.x
	var dimY = botRight.y - topLeft.y
	var pushout = Vector2.ZERO
	#account for 
	var playPos = Vector2(dimX/2, dimY/2)
	#prints("topLeft",topLeft," - botRight",botRight, " - dimX", dimX," - dimY", dimY," - playPos",playPos )
	for y in dimY:
		for x in dimX:
			var index = (y*dimX+x)
			if index >= elementData.size():
				continue
			if(elementData[index] != 0):
				#var push = (Vector2(x,y)-playPos) * -1
				var push = playPos - Vector2(x,y)
				var dir = (playPos - Vector2(x,y))#.normalized()
				pushout += dir

				
				prints("push: ",Vector2(x,y) ,"-",playPos , " = " , (Vector2(x,y)-playPos) )
				#prints("push", push)
				#pushout += push # were to. where from?
				# it needs to point towards zero zerod
				pass
	#pushout = pushout.normalized() #* 2
	prints("pushout: ",pushout)
	if pushout.length() <= 0:
		return false
	var max = -1.0
	var vec = Vector2.ZERO

	#prints("xyxy",botRight.x , topLeft.x, botRight.y , topLeft.y)
	#prints("dimX,Dimy: ",dimX,dimY)
	#prints("PlayerPos: ",playPos, " - Actual pos", position)
	
	#prints("pushout",pushout, " - pushout.dot(Vector2.RIGHT): ", pushout.dot(Vector2.RIGHT))
	#prints("pushout",pushout, " - pushout.dot(Vector2.LEFT): ", pushout.dot(Vector2.LEFT))
	#prints("pushout",pushout, " - pushout.dot(Vector2.UP): ", pushout.dot(Vector2.UP))
	#prints("pushout",pushout, " - pushout.dot(Vector2.DOWN): ", pushout.dot(Vector2.DOWN))
	$Line2D.clear_points()
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(pushout * 5)
	#$Line2D.add_point(playPos)
	#$Line2D.add_point(pushout * 5)
	
	if pushout.dot(Vector2.RIGHT) > max:
		max = pushout.dot(Vector2.RIGHT) 
		vec = Vector2.RIGHT
		$Line2D.default_color = Color.RED
	if pushout.dot(Vector2.LEFT) > max:
		max = pushout.dot(Vector2.LEFT) 
		vec = Vector2.LEFT
		$Line2D.default_color = Color.LIME
	if pushout.dot(Vector2.UP) > max:
		max = pushout.dot(Vector2.UP) 
		vec = Vector2.UP
		$Line2D.default_color = Color.PURPLE
	if pushout.dot(Vector2.DOWN) > max: 
		max = pushout.dot(Vector2.DOWN) 
		vec = Vector2.DOWN
		$Line2D.default_color = Color.GOLD
	pushout = vec.round()
	#prints("pushout",pushout, " - MAX: ", max)
	#$Line2D.clear_points()
	
	position += pushout
	var test_dirs = []
	#if abs(pushout.x) > abs(pushout.y):
	#test_dirs = [Vector2(sign(pushout.x), 0), Vector2(0, sign(pushout.y))]
	#else:
	test_dirs = [Vector2(0, sign(pushout.y)), Vector2(sign(pushout.x), 0)]
	#for dir in test_dirs:
		#position += dir
		#if !is_intersecting_terrain():
			#return false
	#	position -= dir
	
	$Line2D.add_point(Vector2.ZERO)
	$Line2D.add_point(pushout * 5)
	
	return true

func _physics_process(delta): # physics 6 
	var grav = (2.0 * jump_pixels)/(jump_time_to_max_height*jump_time_to_max_height)
	var jump_velo = grav * jump_time_to_max_height
	tidy_drawCharacterOnImage()
	
	# --- COYOTE TIME ---
	if is_on_ground():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)
	
	# --- JUMP BUFFER (optional but recommended) ---
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

	mover.x = get_horizontal_input() #* 2
	var max_fall_speed = 200.0

	# --- GRAVITY ---
	if not is_on_ground():
		mover.y += grav * delta
		if mover.y > max_fall_speed:
			mover.y = max_fall_speed
	else:
		# reset vertical velocity when grounded
		mover.y = 0

# --- VARIABLE JUMP HEIGHT (SHORT HOP) ---
	if Input.is_action_just_released("ui_accept") and mover.y < 0.0:
		mover.y *= jump_cut_multiplier

	# --- JUMP TRIGGER ---
	var wants_jump := jump_buffer_timer > 0.0
	var can_jump := is_on_ground() or coyote_timer > 0.0

	if can_jump and wants_jump:
		mover.y = -jump_velo
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
	
	var lastPosition = position # figure out how ot reconcile this with velocity?	
	var xSteps = int(abs(mover.x ))
	var ySteps = int(abs(mover.y * delta))
	
	# --- MOVE AND RESOLVE CONFLICT ---
	for x in xSteps:
		position.x += sign(mover.x)
		if is_intersecting_terrain():
			# try push up * 2, if still intersecting with terrain, undo pushup, undo x.
			for up in 2: # can move up 2 pixels. 
				position.y -= 1
				if not is_intersecting_terrain():
					break
				elif up == 1:
					print("DOES THIS HAPPENB")
					position.y += 2
					position.x -= sign(mover.x)

	for y in ySteps:
		position.y += sign(mover.y)
		if is_intersecting_terrain():
			position.y -= sign(mover.y)
			break
	#move_and_collide() should I use move and collide instead if pos += ?
	
	# --- RESOLVE CONFLICT IF THINGS MOVE INTO US ---
	if is_intersecting_terrain():
		push_char_from_terrain() # not perfect, causes some jitter, but ok for now
		pass

	#$Label2.text = str(position) 
	#$Label.text = str(Engine.get_frames_per_second())

## the player experience
# exploration and puzzles
# overcoming challangers and mastery - skill growth
# growing inventory. Number go up.
