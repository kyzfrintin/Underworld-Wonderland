extends melee_weapon

var thrown_hammer_res = preload("res://scenes/projectiles/thrown_godhammer.tscn")
var projectiles = []

func on_first_attack():
	$meshes/swing.play()

func throw():
	$meshes.visible = false
	$recall.start()
	var proj = thrown_hammer_res.instance()
	var point = global_transform.origin
	proj.translation = point
	proj.parent = self
	proj.friendly = true
	proj.entity = parent
	proj.damage = primary_damage
	proj.dir = point.direction_to(parent.cast_to)
	proj.destination = parent.cast_to
	parent.game.proj.add_child(proj)
	projectiles.append(proj)

func recall_hammer():
	$meshes.visible = true
	reenable_primary()
