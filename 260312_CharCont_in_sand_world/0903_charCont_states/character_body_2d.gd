extends CharacterBody2D

var facing_right = true

func _process(delta: float) -> void:
		$Sprite.flip_h = facing_right
		$RichTextLabel.text = $MovementController.playerAction.keys()[$MovementController.currentAction]
		$RichTextLabel2.text = $MovementController.playerState.keys()[$MovementController.currentState]
