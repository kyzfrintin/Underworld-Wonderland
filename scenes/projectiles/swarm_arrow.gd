extends Spatial

var phase = 0
var dest = Vector3() setget new_dest
var target
var locked : bool
var dir
var speed = 1
var damage

func new_dest(value):
	dest = value
	dir = translation.direction_to(dest)
	$root.look_at(dest, Vector3.UP)

func _ready():
	match typeof(target):
		TYPE_VECTOR3:
			self.dest = target + Vector3(rand_range(-30,30), rand_range(75,125), rand_range(-30,30))
			locked = false
		TYPE_OBJECT:
			self.dest = target.true_pos.global_transform.origin + Vector3(rand_range(-30,30), rand_range(75,125), rand_range(-30,30))
			locked = true
			target.connect("death", self, "target_death")

func target_death(xp):
	destroy()

func _process(delta):
	translate(dir*speed)
	$tpoint.global_transform.origin = dest
	if translation.distance_to(dest) < speed:
		match phase:
			0:
				if locked:
					self.dest = target.true_pos.global_transform.origin
				else:
					self.dest = target
				phase = 1
			1:
				if !locked:
					destroy()
	if locked:
		if phase == 1:
			self.dest = target.true_pos.global_transform.origin

func destroy():
	call_deferred("queue_free")

func collide(area):
	if phase == 0: return
	if area is base_enemy:
		area.hit(damage, translation, area.translation.direction_to(translation))
		destroy()
