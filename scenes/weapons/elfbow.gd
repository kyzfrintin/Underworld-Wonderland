extends projectile_weapon

onready var swarm_guide_res = preload("res://scenes/projectiles/swarm_arrow_guide.tscn")
onready var swarm_arrow_res = preload("res://scenes/projectiles/swarm_arrow.tscn")

var target = null
var fallback_t : Vector3
var launching = false
var guide

func spawn_guide():
	var sg = swarm_guide_res.instance()
	sg.dir = $meshes/anim_root.global_transform.origin.direction_to(get_node(launch_point).global_transform.origin)
	sg.translation = get_node(launch_point).global_transform.origin
	sg.dest = sg.translation + sg.dir*100
	parent.game.proj.add_child(sg)
	guide = sg
	launching = true

func spawn_rain():
	launching = false
	var pos = guide.global_transform.origin
	$blast.global_transform.origin = pos
	guide.destroy()
	lightning_blast()
	for i in range(6):
		var p = pos + Vector3(rand_range(-7,7), rand_range(-7,7), rand_range(-7,7))
		var sa = swarm_arrow_res.instance()
		sa.translation = p
		sa.target = target
		sa.damage = secondary_damage
		sa.get_node("hit").spawn_node = self
		sa.player = parent
		parent.game.proj.add_child(sa)
		yield(get_tree().create_timer(rand_range(0.01,0.2)), "timeout")

func lightning_blast():
	yield(get_tree().create_timer(0.5), "timeout")
	$blast.play()
	
func mark_target():
	if parent.ray.is_colliding():
		var t = parent.ray.get_collider()
		if t is Object and "friendly" in t:
			if !t.friendly:
				target = t
				target.connect("death", self, "target_dead")
				fallback_t = target.true_pos.global_transform.origin
			else:
				target = parent.cast_point
		else:
				target = parent.cast_point
	else:
		target = parent.cast_point

func target_dead():
	if launching:
		target = fallback_t
