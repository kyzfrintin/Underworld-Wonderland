extends Area

var damage

class_name base_proj_spawner

func _ready():
	on_spawn()
	yield(get_tree().create_timer(0.1), "timeout")
	var cols = get_overlapping_areas() + get_overlapping_bodies()
	for i in cols:
		if "friendly" in i:
			if !i.friendly and i.has_method("hit"):
				i.hit(damage, translation, i.translation.direction_to(translation))

func remove():
	call_deferred("queue_free")

func on_spawn():
	pass
