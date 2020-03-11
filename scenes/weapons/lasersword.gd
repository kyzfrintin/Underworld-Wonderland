extends melee_weapon

func on_first_attack():
	$meshes/swing.play()

func on_second_attack():
	$secondary_tween.interpolate_property($meshes, "translation", holster, (holster - Vector3(0,0,30)), 2, Tween.TRANS_BACK, Tween.EASE_OUT)
	$secondary_tween.start()
	$meshes/looper.play()
	$secondary_hit.start()

func damage():
	var col = $meshes/secondary.get_overlapping_bodies()
	var loc = $meshes/secondary.global_transform.origin
	var nrm = $meshes/secondary.global_transform.origin
	for i in col:
		if i.has_method("hit") and !i.friendly:
			i.hit(secondary_damage, loc, nrm)

func on_end_secondary(object, key):
	$meshes/looper.stop()
	$meshes/swing.play()
	$secondary_hit.stop()
	translation = holster
	reenable_primary()

func secondary_hit():
	damage()
	$secondary_hit.start()


