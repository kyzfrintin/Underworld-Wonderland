extends raycast_weapon

var trail_loc = Vector3(0,-0.017,-1.231)

onready var bt = get_node("trail_point/Bullettrail")
onready var btp = get_node("trail_point")

func heavy_fire():
	var cols = $secondary_damage.get_overlapping_bodies() + $secondary_damage.get_overlapping_areas()
	var loc = $secondary_damage.global_transform.origin
	var nrml = loc
	bullet_trail(true)
	for i in cols:
		if i.has_method("hit"):
			if !i.friendly:
				i.hit(secondary_damage * parent.damage_scale,loc,nrml)

func bullet_trail(wide=false):
	btp.show()
	var dis = bt.global_transform.origin.distance_to(parent.cast_point)
	if !wide:
		btp.scale = (Vector3(1,1,dis*2.5))
	else:
		btp.scale = (Vector3(25,25,300))
	btp.look_at(parent.cast_point, Vector3.UP)
	$meshes/Flare/Flare.rotate_x(rand_range(0,180))
	$meshes/Flare/Flare2.rotate_x(rand_range(0,180))

func reset_bullet():
	btp.hide()
	btp.scale = Vector3(1,1,1)
