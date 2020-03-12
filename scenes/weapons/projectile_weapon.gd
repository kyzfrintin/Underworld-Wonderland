extends weapon

class_name projectile_weapon

export (PackedScene) var projectile
export (NodePath) var launch_point

func attack():
	$AnimationPlayer.play("primary_attack")
	spawn_projectile()

func spawn_projectile():
	var point = get_node(launch_point).global_transform.origin
	var proj = projectile.instance()
	proj.translation = point
	proj.parent = self
	proj.friendly = true
	proj.get_node("spawn_sound").spawn_node = self
	proj.dir = point.direction_to(parent.cast_point)
	parent.game.proj.add_child(proj)