@tool
extends EditorPlugin

const INPUT_DIR := "res://mixamo_input"
const OUTPUT_DIR := "res://animation_output"

func _enter_tree() -> void:
	add_tool_menu_item("Convert Mixamo Animations", add_bones_to_import_files)
	DirAccess.make_dir_recursive_absolute(OUTPUT_DIR)

#add_bones_to_import_files()
# |- modify_import_file()
# |- reimport_file()
# |- extract_anims_and_save()

func add_bones_to_import_files() -> void:
	var dir := DirAccess.open(INPUT_DIR)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".fbx"):
			modify_import_file(INPUT_DIR + "/" + file_name + ".import")
			reimport_file(INPUT_DIR + "/" + file_name)
			extract_anims_and_save(INPUT_DIR + "/" + file_name)

		file_name = dir.get_next()
	print("Conversion finished")

func reimport_file(path):
	var fs := get_editor_interface().get_resource_filesystem()
	fs.reimport_files(PackedStringArray([path]))
	prints("Reimported:", path)


func modify_import_file(data_string):
	var file = FileAccess.open(data_string, FileAccess.READ_WRITE)
	if file:
		# Use store_string or store_line to write the raw string data
		var entire_file = file.get_as_text()
		var replacement = '_subresources={
"nodes": {
"PATH:Skeleton3D": {
"retarget/bone_map": Object(BoneMap,"resource_local_to_scene":false,"resource_name":"","profile":Object(SkeletonProfileHumanoid,"resource_local_to_scene":false,"resource_name":"","root_bone":&"Root","scale_base_bone":&"Hips","group_size":4,"bone_size":56,"script":null)
,"bonemap":null,"bone_map/Root":&"","bone_map/Hips":&"mixamorig_Hips","bone_map/Spine":&"mixamorig_Spine","bone_map/Chest":&"mixamorig_Spine1","bone_map/UpperChest":&"mixamorig_Spine2","bone_map/Neck":&"mixamorig_Neck","bone_map/Head":&"mixamorig_Head","bone_map/LeftEye":&"","bone_map/RightEye":&"","bone_map/Jaw":&"","bone_map/LeftShoulder":&"mixamorig_LeftShoulder","bone_map/LeftUpperArm":&"mixamorig_LeftArm","bone_map/LeftLowerArm":&"mixamorig_LeftForeArm","bone_map/LeftHand":&"mixamorig_LeftHand","bone_map/LeftThumbMetacarpal":&"mixamorig_LeftHandThumb1","bone_map/LeftThumbProximal":&"mixamorig_LeftHandThumb2","bone_map/LeftThumbDistal":&"mixamorig_LeftHandThumb3","bone_map/LeftIndexProximal":&"mixamorig_LeftHandIndex1","bone_map/LeftIndexIntermediate":&"mixamorig_LeftHandIndex2","bone_map/LeftIndexDistal":&"mixamorig_LeftHandIndex3","bone_map/LeftMiddleProximal":&"mixamorig_LeftHandMiddle1","bone_map/LeftMiddleIntermediate":&"mixamorig_LeftHandMiddle2","bone_map/LeftMiddleDistal":&"mixamorig_LeftHandMiddle3","bone_map/LeftRingProximal":&"mixamorig_LeftHandRing1","bone_map/LeftRingIntermediate":&"mixamorig_LeftHandRing2","bone_map/LeftRingDistal":&"mixamorig_LeftHandRing3","bone_map/LeftLittleProximal":&"mixamorig_LeftHandPinky1","bone_map/LeftLittleIntermediate":&"mixamorig_LeftHandPinky2","bone_map/LeftLittleDistal":&"mixamorig_LeftHandPinky3","bone_map/RightShoulder":&"mixamorig_RightShoulder","bone_map/RightUpperArm":&"mixamorig_RightArm","bone_map/RightLowerArm":&"mixamorig_RightForeArm","bone_map/RightHand":&"mixamorig_RightHand","bone_map/RightThumbMetacarpal":&"mixamorig_RightHandThumb1","bone_map/RightThumbProximal":&"mixamorig_RightHandThumb2","bone_map/RightThumbDistal":&"mixamorig_RightHandThumb3","bone_map/RightIndexProximal":&"mixamorig_RightHandIndex1","bone_map/RightIndexIntermediate":&"mixamorig_RightHandIndex2","bone_map/RightIndexDistal":&"mixamorig_RightHandIndex3","bone_map/RightMiddleProximal":&"mixamorig_RightHandMiddle1","bone_map/RightMiddleIntermediate":&"mixamorig_RightHandMiddle2","bone_map/RightMiddleDistal":&"mixamorig_RightHandMiddle3","bone_map/RightRingProximal":&"mixamorig_RightHandRing1","bone_map/RightRingIntermediate":&"mixamorig_RightHandRing2","bone_map/RightRingDistal":&"mixamorig_RightHandRing3","bone_map/RightLittleProximal":&"mixamorig_RightHandPinky1","bone_map/RightLittleIntermediate":&"mixamorig_RightHandPinky2","bone_map/RightLittleDistal":&"mixamorig_RightHandPinky3","bone_map/LeftUpperLeg":&"mixamorig_LeftUpLeg","bone_map/LeftLowerLeg":&"mixamorig_LeftLeg","bone_map/LeftFoot":&"mixamorig_LeftFoot","bone_map/LeftToes":&"mixamorig_LeftToeBase","bone_map/RightUpperLeg":&"mixamorig_RightUpLeg","bone_map/RightLowerLeg":&"mixamorig_RightLeg","bone_map/RightFoot":&"mixamorig_RightFoot","bone_map/RightToes":&"mixamorig_RightToeBase","script":null)

}
}
}'
		entire_file = entire_file.replace("_subresources={}", replacement)
		print(entire_file)
		file.store_string(entire_file)
		file.close()
		print("String saved successfully without quotes.")
	else:
		print("Error opening file for writing.")

func extract_anims_and_save(model_path: String):
	# Load imported scene
	var packed_scene := load(model_path) as PackedScene
	if not packed_scene:
		push_error("Failed to load: " + model_path)
		return

	var root := packed_scene.instantiate()

	# --- Extract animations ---
	var anim_player := root.find_child("AnimationPlayer", true, false) as AnimationPlayer
	if not anim_player:
		push_error("No AnimationPlayer found in " + model_path)
		return
	anim_player.get_animation_library("")
	# remove take_001
	for lib in anim_player.get_animation_library_list():
		var anim := anim_player.get_animation_library(lib)
		if anim == null:
			continue
		if anim.has_animation("Take 001"):
			anim.remove_animation("Take 001")
	# Make unique
		var unique_anim := anim.duplicate(true)
		var save_path := OUTPUT_DIR + "/" + "%s_%s.res" % [
			"anim_",
			model_path.get_file().get_basename()
		]
		ResourceSaver.save(unique_anim, save_path)

func _exit_tree() -> void:
	remove_tool_menu_item("Convert Mixamo Animations")

#### Don't use anything below ####
func _convert_selected() -> void:
	var editor := get_editor_interface()
	var selection := editor.get_selection()
	var fs := editor.get_resource_filesystem()
	#var paths: PackedStringArray = editor.get_selected_files()

	if not DirAccess.dir_exists_absolute(INPUT_DIR):
		push_error("Input dir not found: %s" % INPUT_DIR)
		return

	var dir := DirAccess.open(INPUT_DIR)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".fbx"):
			_process_model(INPUT_DIR + "/" + file_name)
		file_name = dir.get_next()

func _process_model(model_path: String) -> void:
	# Load imported scene
	var packed_scene := load(model_path) as PackedScene
	if not packed_scene:
		push_error("Failed to load: " + model_path)
		return

	var root := packed_scene.instantiate()

	# Find Skeleton3D
	var skeleton := root.find_child("Skeleton3D", true, false) as Skeleton3D
	if not skeleton:
		push_error("No Skeleton3D found in " + model_path)
		return

	# --- Retarget setup ---
	var bone_map := BoneMap.new()
	bone_map.profile = SkeletonProfileHumanoid.new()
	skeleton.set_bone_map(bone_map)

	# --- Force reimport ---
	var fs := get_editor_interface().get_resource_filesystem()
	fs.reimport_files(PackedStringArray([model_path]))
	# --- Create inherited scene ---
	var inherited := PackedScene.new()
	
	if inherited.pack(root) != OK:
		push_error("Failed to pack inherited scene for " + model_path)
		return

	var inherited_path := model_path.get_basename() + "_inherited.tscn"
	ResourceSaver.save(inherited, inherited_path)

	# --- Extract animations ---
	var anim_player := root.find_child("AnimationPlayer", true, false) as AnimationPlayer
	if not anim_player:
		push_error("No AnimationPlayer found in " + model_path)
		return

	for anim_name in anim_player.get_animation_list():
		var anim := anim_player.get_animation(anim_name)
		if anim == null:
			continue

		# Make unique
		var unique_anim := anim.duplicate(true)

		var save_path := OUTPUT_DIR + "%s_%s.res" % [
			model_path.get_file().get_basename(),
			anim_name
		]

		ResourceSaver.save(unique_anim, save_path)
