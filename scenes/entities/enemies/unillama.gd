extends base_enemy

var can_stab = false
export var targeting = false
onready var beam = $body/laserbeam

func on_death():
	if $attack_tween.is_active():
		$attack_tween.stop(self, "translation")

func charge():
	var cpos : Vector3 = global_transform.origin
	var ppos : Vector3 = target_pos
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	var pos = (cpos + (dir * (dis - 2)))
	pos = nav_spot(pos)
	can_stab = true
	$attack_tween.interpolate_property(self, "translation", global_transform.origin, pos, (0.5*(dis/25)), Tween.TRANS_BACK, Tween.EASE_IN)
	$attack_tween.start()

func _process(delta):
	if targeting:
		beam_target()

func beam_target():
	var t_pos = target_pos
	face_target(t_pos)
	$cast.enabled = true
	var loc = beam.global_transform.origin
	$cast.look_at(target_pos, Vector3(0,1,0))
	beam.look_at(target_pos, Vector3(0,1,0))
	var cast_pos = $cast.get_collision_point()
	beam.scale.z = loc.distance_to(cast_pos) * 5

func beam_attack():
	var col = $cast.get_collider()
	var loc = $cast.get_collision_point()
	var nrm = $cast.get_collision_normal()
	if !col: return
	if col.has_method("hit"):
		if col.friendly:
			col.hit(attack_dict.get(current_attack).get("damage"), loc, nrm, self)
			
	$cast.enabled = false
	
func end_charge(object, key):
	attack_over()

func collided_with_player(body):
	if can_stab:
		var nrml = body.translation.direction_to(global_transform.origin)
		body.hit(attack_dict.get(current_attack).get("damage"), global_transform.origin, nrml)
		can_stab = false

func anim_finished(anim_name):
	if anim_name == "die":
		delete()
