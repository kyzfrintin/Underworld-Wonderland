extends base_enemy

var can_hit = false

func on_death():
	if $attack_tween.is_active():
		$attack_tween.stop(self, "translation")

func charge():
	var cpos : Vector3 = player_pos
	var ppos : Vector3 = player.global_transform.origin
	face_target(ppos)
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	var pos = (cpos + (dir * (dis * 1.4)))
	pos = nav_spot(pos)
	can_hit = true
	$attack_tween.interpolate_property(self, "translation", global_transform.origin, pos, (0.4*(dis/25)), Tween.TRANS_SINE, Tween.EASE_OUT)
	$attack_tween.start()

func spear_over(object, key):
	attack_over()

func collided_with_player(body):
	if can_hit:
		var nrml = body.translation.direction_to(global_transform.origin)
		body.hit(attack_dict.get(current_attack).get("damage"), global_transform.origin, nrml)
		can_hit = false
