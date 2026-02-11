extends Ability
class_name Hover

@export var gravity_scale := 0.3

func on_equip(player): pass
func on_unequip(player): pass

func _tick(player, delta):

	if Input.is_action_pressed("jump") and not player.is_on_floor() and player.velocity.y > 0:
		player.velocity.y -= player.gravity * (1.0 - gravity_scale) * delta
