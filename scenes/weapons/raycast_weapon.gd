extends weapon

class_name raycast_weapon

func attack():
	$AnimationPlayer.play("primary_attack")
	var col = cast.get_collider()
	var loc = cast.get_collision_point()
	var nrml = cast.get_collision_normal()
	if col:
		if col.has_method("hit"):
			col.hit(primary_damage * parent.damage_scale,loc,nrml, parent)
			shot(loc)

func shot(loc):
	pass
