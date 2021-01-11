extends weapon

class_name aoe_weapon

export (NodePath) var hurt_box

func attack():
	$AnimationPlayer.play("primary_attack")

func parse_attack():
	var col = get_node(hurt_box).get_overlapping_areas() + get_node(hurt_box).get_overlapping_bodies()
	var loc = get_node(hurt_box).global_transform.origin
	var nrm = get_node(hurt_box).global_transform.origin
	for i in col:
		if i.has_method("hit"):
			i.hit(primary_damage, loc, nrm, parent)
