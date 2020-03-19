extends melee_weapon

var thrown_sword_res = preload("res://scenes/projectiles/thrown_ds_sword.tscn")

func on_first_attack():
	$meshes/swing.play()

func throw():
	$meshes.visible = false
	$recall.start()
	var sword = thrown_sword_res.instance()
	var point = global_transform.origin
	sword.destination = parent.cast_point
	sword.translation = point
	sword.parent = self
	sword.dir = point.direction_to(parent.cast_point)
	parent.game.proj.call_deferred("add_child", sword)

func recall_sword():
	$meshes.visible = true
	reenable_primary()
