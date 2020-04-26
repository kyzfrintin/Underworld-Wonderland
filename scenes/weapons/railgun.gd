extends aoe_weapon

onready var bt = get_node("trail_point/Bullettrail")
onready var btp = get_node("trail_point")

func heavy_fire():
	var cols = $damage.get_overlapping_bodies() + $damage.get_overlapping_areas()
	var loc = $damage.global_transform.origin
	var nrml = loc
	bullet_trail()
	for i in cols:
		if i.has_method("hit"):
			if !i.friendly:
				i.hit(primary_damage * parent.damage_scale,loc,nrml)

func bullet_trail():
	btp.show()
	var dis = bt.global_transform.origin.distance_to(parent.cast_point)
	btp.scale = (Vector3(1,1,dis*2.5))
	btp.look_at(parent.cast_point, Vector3.UP)
	
func reset_bullet():
	btp.hide()
	btp.scale = Vector3(1,1,1)
