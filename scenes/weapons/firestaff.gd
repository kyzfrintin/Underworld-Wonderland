extends projectile_weapon

func on_second_attack():
	$charge_swarm.play()

func swarm():
	var point = get_node(launch_point).global_transform.origin
	var fb = projectile.instance()
	fb.translation = point
	fb.swarm = true
	fb.get_node("spawn_sound").spawn_node = self
	fb.get_node("MeshInstance").scale = Vector3(0.05,0.05,0.05)
	fb.translation += Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1))
	fb.parent = self
	fb.dir = point.direction_to(parent.cast_point)
	parent.game.proj.call_deferred("add_child", fb)
	projectiles.append(fb)
