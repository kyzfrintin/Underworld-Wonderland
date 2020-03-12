extends base_enemy

var can_hit = false

func on_death():
	if $attack_tween.is_active():
		$attack_tween.stop(parent, "translation")

func charge():
	var cpos : Vector3 = parent.global_transform.origin
	var ppos : Vector3 = parent.player.global_transform.origin
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	var pos = (cpos + (dir * (dis * 1.4)))
	$cube/hit_zone.monitoring = true
	can_hit = true
	$attack_tween.interpolate_property(parent, "translation", parent.global_transform.origin, pos, (0.4*(dis/25)), Tween.TRANS_SINE, Tween.EASE_OUT)
	$attack_tween.start()

func on_end_attack():
	$cube/hit_zone.monitoring = false
	
func spear_over(object, key):
	attack_over()

func collide(body):
	if can_hit:
		var nrml = body.translation.direction_to(global_transform.origin)
		if body.has_method("hit") and body.friendly:
			body.hit(attack_dict.get(current_attack).get("damage"), global_transform.origin, nrml)
			can_hit = false

