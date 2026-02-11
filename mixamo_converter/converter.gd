@tool
extends Node

const INPUT_DIR := "res://mixamo_input"
const OUTPUT_DIR := "res://animation_output"

func _ready():
	return
	_run() # Run the conversion when the scene starts

func _run() -> void:
	print("=== Mixamo conversion started ===")

	if not DirAccess.dir_exists_absolute(INPUT_DIR):
		push_error("Input dir not found: %s" % INPUT_DIR)
		return

	var dir := DirAccess.open(INPUT_DIR)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".fbx"):
			_process_fbx(INPUT_DIR + "/" + file_name)
		file_name = dir.get_next()

	print("=== Mixamo conversion finished ===")


func _process_fbx(fbx_path: String) -> void:
	print("Processing:", fbx_path)

	var scene: PackedScene = load(fbx_path)
	if scene == null:
		push_error("Failed to load " + fbx_path)
		return

	var root := scene.instantiate()

	var skeleton := _find_skeleton(root)
	if skeleton == null:
		push_error("No Skeleton3D found in " + fbx_path)
		root.queue_free()
		return

	# Bone map + humanoid profile (if available)
	# this is why it's broken
	if Engine.has_singleton("BoneMap") and Engine.has_singleton("SkeletonProfileHumanoid"):
		var bone_map := BoneMap.new()
		bone_map.profile = SkeletonProfileHumanoid.new()
		bone_map.create_from_skeleton(skeleton)
		skeleton.bone_map = bone_map

	var anim_player := _find_animation_player(root)
	if anim_player == null:
		push_error("No AnimationPlayer found in " + fbx_path)
		root.queue_free()
		return

	if not DirAccess.dir_exists_absolute(OUTPUT_DIR):
		DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)

	var model_name := fbx_path.get_file().get_basename()

	for anim_name in anim_player.get_animation_list():
		var anim := anim_player.get_animation(anim_name).duplicate()
		var save_path := "%s/%s_%s.tres" % [OUTPUT_DIR, model_name, anim_name]
		var err = ResourceSaver.save(anim, save_path)
		if err != OK:
			push_error("Failed to save %s" % save_path)
		else:
			print("Saved:", save_path)

	root.queue_free()


func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var res := _find_skeleton(child)
		if res:
			return res
	return null


func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var res := _find_animation_player(child)
		if res:
			return res
	return null
