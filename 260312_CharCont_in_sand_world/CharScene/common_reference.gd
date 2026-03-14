extends Node

@onready var main: Main = get_tree().get_root().get_node("main")
#@onready var save_file_manager: SaveFileManager = get_tree().get_root().get_node("Main/%SaveFileManager")
@onready var canvas: Canvas = get_tree().get_root().get_node("Main/%Canvas")
#@onready var painter: Painter = get_tree().get_root().get_node("Main/%Painter")
#@onready var element_manager: ElementManager = get_tree().get_root().get_node("Main/%ElementManager")
@onready var SandWorldRef : SandWorld #= get_tree().get_root().get_node("SandWorld")

# not sure where to put these really.
@onready var viewport_width : int = 192 * 2# x
@onready var viewport_height : int = 128 * 2 # y

@export var window_width : int # x - multiple of viewport_width - factor is how much we stretch in x
@export var window_height : int  # y - multiple of viewport_height - factor is how much we stretch in y 

# I'm going to need something like this >:(

func _ready() -> void:
	SandWorldRef= get_tree().get_root().get_node("main/SandWorld")
	#prints("IS SAND ACTIVE", SandWorldRef.active)
	#await get_tree().get_root().ready
	
func get_sand_world_reference():
	return SandWorldRef
