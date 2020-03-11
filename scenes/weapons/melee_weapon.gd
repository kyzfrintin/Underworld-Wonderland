extends weapon

class_name melee_weapon

export (NodePath) var hurt_box
var holster : Vector3

func on_equip():
	holster = translation

func attack():
	if right_hand:
		$AnimationPlayer.play("prim_right")
	else:
		$AnimationPlayer.play("prim_left")

func melee_attack():
	var col = get_node(hurt_box).get_overlapping_bodies()
	var loc = get_node(hurt_box).global_transform.origin
	var nrm = get_node(hurt_box).global_transform.origin
	for i in col:
		if i.has_method("hit") and !i.friendly:
			i.hit(primary_damage, loc, nrm)
