extends Node3D

signal animation_event(event_name)
signal animation_finished(animation_name)

func animationCall():
	#$AnimationPlayer.play("universialAnimations_2/Sword_Regular_A",0.2)
	pass

func emit_anim_event(event_name : String):
	animation_event.emit(event_name)

# lock, disable_interrupt, hitbox_on/off, unlock

var anims = [
"universialAnimations/Jump",
"universialAnimations/Jog_Fwd",
"universialAnimations/Sword_Attack",
"universialAnimations/Roll",
"universialAnimations_2/Consume",
"universialAnimations_2/Sword_Regular_A",
"universialAnimations_2/Sword_Dash_RM",
"universialAnimations_2/Melee_Hook",
"universialAnimations_2/NinjaJump_Idle",
"universialAnimations_2/Sword_Regular_B",
"universialAnimations_2/Slide",
"universialAnimations_2/OverhandThrow",
"universialAnimations_2/ClimbUp_1m_RM",
"universialAnimations/Death01"
]




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
	pass # Replace with function body.
