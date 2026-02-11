# Ability.gd
#extends RefCounted
extends Resource
class_name Ability

# maybe crash game if these are not overridden -> so i don't forget
func on_equip(player): pass
func on_unequip(player): pass
func _tick(player, delta): pass
