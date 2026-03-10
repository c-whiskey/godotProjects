# How to import a 3d model and retarget animations


# First lets import the model which we wish to transfer animations to

You'll either have a GLB or FBX file exported from blender... or wherever.
Double click that file, a window will open up.
What you need to do is give the model a godot skeleton so the animations know what to target.
Godot can usually match the godot skeleton to the model skeleton bones if they have the same name.
Anyways
With window open (in this example running.fbx)
	click Skeleton3D
		- retarget
			- bonemap -> new bonemap
			- profile -> new skeletonProfileHumanoid
	click the reimport button

Ok, So now we need to create an inherited scene.
	Right click running.fbx 
		-> new inherited scene
		then save the inherited scene somewhere.
		THEN in the scene panel, right click the root
			-> clear inheritance. (otherwise you can't edit anything)
		
# Ok, we have the target model setup.
# now we need to extract the animations from our donor
Similar to before we need to do the same with the donor model 
	-> open ual1_standard.glb, do bonemap and humanoid skeleton
	-> reimport
	-> new inherited scene, save, clear inheritance, save again

# Extracting the animations
in the ual1_standard scene click on the animationPLayer
in the animation tab, click the 'Animation' button, next to the animation selector, and the play buttons.
	-> manage animations
	-> select animations, or export the the root library by clicking the save icons
	-> I saved in runnningScene as universialAnimations.res
	
	
# Back to our target scene (runningInherited.tscn)
select the animation player
-> manage animations
	-> load library and selected our saved resource

Hey presto, you have transferred some animations from one model to another.














x
