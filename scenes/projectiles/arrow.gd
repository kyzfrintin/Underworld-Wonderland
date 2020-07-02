extends projectile

func on_contact(pos):
	$hit.play()

func on_activate():
	$hit.spawn_node = $spawn_sound.spawn_node
	$Root.look_at(destination, Vector3(0,1,0))
	$CollisionShape.rotation = $Root.rotation
	var rpos = $CollisionShape.global_transform.origin
	var mpos = $Root/mid.global_transform.origin
	var pos = rpos.direction_to(mpos) * rpos.distance_to(mpos)
	$CollisionShape.global_transform.origin += pos
