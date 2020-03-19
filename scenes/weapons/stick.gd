extends melee_weapon

func clobber():
	var col = get_node(hurt_box).get_overlapping_bodies() + get_node(hurt_box).get_overlapping_areas()
	var loc = get_node(hurt_box).global_transform.origin
	var nrm = get_node(hurt_box).global_transform.origin
	for i in col:
		if i.has_method("hit") and !i.friendly:
			i.hit(secondary_damage, loc, nrm)
