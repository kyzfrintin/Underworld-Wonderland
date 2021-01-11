extends raycast_weapon

var firing = false
var missile_res = preload("res://scenes/projectiles/proton_missile.tscn")
var projectiles = []
var turning_up = true

func _process(delta):
	if primary_held:
		if firing == false:
			firing = true
			mod_loop_vol(true)
		var col = cast.get_collider()
		var loc = cast.get_collision_point()
		var nrml = cast.get_collision_normal()
		if col:
			if col.has_method("hit"):
				col.hit(primary_damage * parent.damage_scale,loc,nrml, parent)
				shot(loc)
		var dis = $beam.global_transform.origin.distance_to(parent.cast_point)
		$beam.look_at(parent.cast_point, Vector3.UP)
		$beam.scale = (Vector3(1,1,dis))
		$shoot_loop.pitch_scale = rand_range(0.55, 0.65)
	else:
		if firing == true:
			firing = false
			mod_loop_vol(false)
	$teslazooka/Tube/EnergyRing.rotate_y(deg2rad(-3))

func mod_loop_vol(up = true):
	if up:
		$beam.show()
		$shoot_loop.play()
		$Tween.interpolate_property($shoot_loop, "unit_db", -60, 0, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	else:
		$beam.hide()
		$Tween.interpolate_property($shoot_loop, "unit_db", 0, -60, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		$shoot_loop.stop()

func heavy_fire():
	var missile = missile_res.instance()
	var pos = $launch_point.global_transform.origin
	missile.translation = pos
	missile.parent = self
	missile.friendly = true
	missile.entity = parent
	missile.damage = secondary_damage
	missile.get_node("spawn_sound").spawn_node = self
	missile.dir = pos.direction_to(parent.cast_to)
	missile.destination = parent.cast_to
	parent.game.proj.add_child(missile)
	projectiles.append(missile)
