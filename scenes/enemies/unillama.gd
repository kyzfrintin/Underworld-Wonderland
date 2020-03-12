extends base_enemy

var can_stab = false

func on_death():
	if $attack_tween.is_active():
		$attack_tween.stop(parent, "translation")

func charge():
	var cpos : Vector3 = parent.global_transform.origin
	var ppos : Vector3 = parent.player.global_transform.origin
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	var pos = (cpos + (dir * (dis - 7)))
	can_stab = true
	$Armature/Unillama/hit_zone.monitoring = true
	$attack_tween.interpolate_property(parent, "translation", parent.global_transform.origin, pos, (0.5*(dis/25)), Tween.TRANS_BACK, Tween.EASE_IN)
	$attack_tween.start()

func on_end_attack():
	$Armature/Unillama/hit_zone.monitoring = false
	
func beam_target():
	$cast.enabled = true
	var loc = $laserbeam.global_transform.origin
	$cast.look_at(parent.get_node("states/attack").target_pos, Vector3(0,1,0))
	$laserbeam.look_at(parent.get_node("states/attack").target_pos, Vector3(0,1,0))
	var cast_pos = $cast.get_collision_point()
	$laserbeam.scale.z = loc.distance_to(cast_pos) * 5

func beam_attack():
	var col = $cast.get_collider()
	var loc = $cast.get_collision_point()
	var nrm = $cast.get_collision_normal()
	if !col: return
	if col.has_method("hit"):
		if col.friendly:
			col.hit(attack_dict.get(current_attack).get("damage"), loc, nrm)
			
	$cast.enabled = false
	
func end_charge(object, key):
	attack_over()

func horn_stab(body):
	if can_stab:
		var nrml = body.translation.direction_to(global_transform.origin)
		if body.has_method("hit") and body.friendly:
			body.hit(attack_dict.get(current_attack).get("damage"), global_transform.origin, nrml)
			can_stab = false

