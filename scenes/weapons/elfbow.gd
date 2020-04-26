extends projectile_weapon

onready var swarm_guide_res = preload("res://scenes/projectiles/swarm_arrow_guide.tscn")
onready var swarm_arrow_res = preload("res://scenes/projectiles/swarm_arrow.tscn")

var target = null
var guide

func spawn_guide():
	var sg = swarm_guide_res.instance()
	sg.dir = $meshes/anim_root.global_transform.origin.direction_to(get_node(launch_point).global_transform.origin)
	sg.translation = get_node(launch_point).global_transform.origin
	sg.get_node("Root").look_at(sg.dir, Vector3.UP)
	parent.game.proj.add_child(sg)
	guide = sg

func spawn_rain():
	var pos = guide.global_transform.origin
	guide.destroy()
	for i in range(6):
		var p = pos + Vector3(rand_range(-7,7), rand_range(-7,7), rand_range(-7,7))
		var sa = swarm_arrow_res.instance()
		sa.translation = p
		sa.target = target
		sa.damage = secondary_damage
		parent.game.proj.add_child(sa)
	
func mark_target():
	if parent.ray.is_colliding():
		var t = parent.ray.get_collider()
		if t is base_enemy:
			target = t
		else:
			target = parent.cast_point
	else:
		target = parent.cast_point
