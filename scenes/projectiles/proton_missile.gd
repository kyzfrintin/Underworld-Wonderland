extends projectile

func on_activate():
	$missile_root.look_at(translation+(dir*20), Vector3.UP)

func collision(obj):
	collide(obj)
