extends Area

class_name projectile

export (float) var speed

var parent
var dir
var active
var swarm
var friendly

func _ready():
	if swarm:
		active = false
		yield(get_tree().create_timer(1), "timeout")
		$Timer.start()
		activate()
	else:
		activate()
		$Timer.start()

func activate():
	active = true
	$spawn_sound.play()
	on_activate()
	
func collide(body):
	if !active: return
	if body.has_method("hit"):
		if !body.friendly == friendly:
			body.hit(parent.primary_damage, translation, body.global_transform.origin.direction_to(translation))
	remove()

func _process(delta):
	if $MeshInstance.scale < Vector3(1,1,1):
		$MeshInstance.scale += Vector3(0.07,0.07,0.07)
	if active:
		translate(dir*speed)

func remove():
	call_deferred("queue_free")

func on_activate():
	pass
