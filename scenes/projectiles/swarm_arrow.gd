extends Spatial

var phase = 0
var dest = Vector3() setget new_dest
var target
var locked : bool
var dir
var speed = 1
var damage
var active = false
var player

func new_dest(value):
	dest = value
	dir = translation.direction_to(dest)
	$root.look_at(dest, Vector3.UP)

func _ready():
	player.connect("death", self, "target_death")
	match typeof(target):
		TYPE_VECTOR3:
			self.dest = target + Vector3(rand_range(-50,50), rand_range(50,75), rand_range(-50,50))
			locked = false
		TYPE_OBJECT:
			target.connect("death", self, "target_death")
			self.dest = target.true_pos.global_transform.origin + Vector3(rand_range(-50,50), rand_range(50,75), rand_range(-50,50))
			locked = true
	active = true

func target_death(xp):
	active = false
	destroy()

func _process(delta):
	if !active: return
	translate(dir*speed)
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
					$hit.play()
					destroy()
	if locked:
		if phase == 1:
			if target == null:
				destroy()
			else:
				self.dest = target.true_pos.global_transform.origin

func destroy():
	call_deferred("queue_free")

func collide(area):
	if phase == 0: return
	$hit.play()
	if area.has_method('hit'):
		area.hit(damage, translation, area.translation.direction_to(translation))
		destroy()
