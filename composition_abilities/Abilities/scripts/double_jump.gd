extends Ability
class_name DoubleJump

var jumps_left := 1

func on_equip(player): pass
func on_unequip(player): pass

func _tick(player, delta):
	if not Input.is_action_just_pressed("jump"):
		return

	if player.is_on_floor():
		jumps_left = 1
		return

	if jumps_left > 0:
		jumps_left -= 1
		player.velocity.y = -300
