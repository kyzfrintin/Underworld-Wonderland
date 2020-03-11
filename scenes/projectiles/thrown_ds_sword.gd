extends Spatial

var parent
var dir
var destination
var speed = 2

func _ready():
	$meshes.look_at(destination, Vector3(0,1,0))

func collide(body):
	if body.has_method("hit"):
		if !body.friendly:
			body.hit(parent.secondary_damage, translation, body.global_transform.origin.direction_to(translation))

func _process(delta):
	$meshes.rotation += Vector3(0,0,0.4)
	translate(dir*speed)

func remove():
	call_deferred("queue_free")
