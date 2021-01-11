extends base_entity

onready var cast = $body/Armature/Barrel/beam/shot_cast
onready var beam = $body/Armature/Barrel/beam

func init():
	global_transform.origin = nav_spot(global_transform.origin)
	friendly = true
	leader = player
	restate("emerge")
	
#func on_change():
#	print(name + ' changing to ' + state)

func ready_shot():
	cast.enabled = true
	var t_pos = target_pos
#	face_target(t_pos)
	var loc = beam.global_transform.origin
	var cast_pos = cast.get_collision_point()
	beam.scale.y = loc.distance_to(cast_pos)
	beam.show()

func _process(delta):
	if target:
		$body/Armature/Barrel.look_at(target_pos, Vector3(0,1,0))
		$target.global_transform.origin = target_pos
		
func shot():
#	$body/Armature/Barrel.look_at(target_pos, Vector3(0,1,0))
	var col = cast.get_collider()
	var loc = cast.get_collision_point()
	var nrm = cast.get_collision_normal()
	if !col: return
	print('zigurrat shot ' + col.name)
	if col.has_method("hit"):
		if !col.friendly:
			col.hit(attack_dict.get(current_attack).get("damage"), loc, nrm, self)
			
	cast.enabled = false
	beam.hide()
	
func tempest_begin():
	$tempest_hurtbox.monitoring = true

func tempest_shot():
	var cols = $tempest_hurtbox.get_overlapping_areas() + $tempest_hurtbox.get_overlapping_bodies()
	var loc = cast.get_collision_point()
	var nrm = cast.get_collision_normal()
	if cols.size() > 0:
		for i in cols:
			if i.has_method("hit"):
				i.hit(attack_dict.get(current_attack).get("damage"), i.global_transform.origin, i.global_transform.origin, self)
	yield(get_tree().create_timer(0.2), "timeout")
	$tempest_hurtbox.monitoring = false

func on_kill(xp):
	target_dead = true
	target = null
#	detect.monitoring = true
	restate("follow")
#	reacq.start(reacquire_speed)
	leader.enemy_killed(xp)
