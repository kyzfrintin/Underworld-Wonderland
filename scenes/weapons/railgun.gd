extends aoe_weapon

onready var bt = get_node("trail_point/Bullettrail")
onready var btp = get_node("trail_point")
onready var rp_res = preload("res://scenes/projectiles/rail_proj.tscn")

var projectiles = []

func heavy_fire():
	var rp = rp_res.instance()
	var pos = $railgun/rp_pos.global_transform.origin
	rp.translation = pos
	rp.parent = self
	rp.friendly = true
	rp.damage = secondary_damage
	rp.get_node("spawn_sound").spawn_node = self
	rp.dir = pos.direction_to(parent.cast_to)
	rp.destination = parent.cast_to
	parent.game.proj.add_child(rp)
	projectiles.append(rp)

func bullet_trail():
	btp.show()
	var dis = bt.global_transform.origin.distance_to(parent.cast_to)
	btp.scale = (Vector3(1,1,dis*2.5))
#	btp.look_at(parent.cast_point, Vector3.UP)
	
func reset_bullet():
	btp.hide()
	btp.scale = Vector3(1,1,1)

func player_death():
	for i in projectiles:
		i.call_deferred("queue_free")
