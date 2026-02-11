This is a super simple tool used to automatically extract animation resouces from mixamo 
animated characters for the purposes of animation mesh retargeting.

1. Place downloaded mixamo animations in the mixamo_input folder 
2. In the editor, Project -> tools -> convert mixamo animations
3. Output animation resource files are placed in /animation_output

Each animation is saved as an animation library

It basically does the following automatically:
	Open the model (double click in file system)
	-> click on the skeleton3d node
		-> under inspector retarget
				-> bone map -> new bone map
					-> under bonemap  -> new skeletonProfileHumanoid
	
	click the reimport button to reimport the model
	
	in file system right click the model, new inherited scene
		click animationPlayer in sceneTab
			->manage animations
			->root animation make unique
			->root animation save as
			->save as a resource somewhere.
			
Note, in order to use these animations you must also have a matching skeleton on the model to retarget.
-> click on the skeleton3d node
	-> under inspector retarget
			-> bone map -> new bone map
				-> under bonemap  -> new skeletonProfileHumanoid
				
	-> create a scene for our new model
	-> create an animation player
	-> manage animations
	-> load library
		-> select the saved resourced