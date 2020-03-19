extends Area

class_name projectile

export (float) var speed
export (String, "Absorb", "AOE", "Timed", "Aura") var type = "Absorb"
export (PackedScene) var spawner

var parent
var dir
var active
var swarm
var friendly

func _ready():
	connect("area_entered", self, "collide")
	connect("body_entered", self, "collide")
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
	on_contact(translation)
	if body.has_method("hit"):
		if !body.friendly == friendly:
			print('collided with %s' % body.name)
			print('projecile is %s' % type)
			match type:
				"Absorb":
					body.hit(parent.primary_damage, translation, body.global_transform.origin.direction_to(translation))
				"AOE":
					var s = spawner.instance()
					s.translation = translation
					get_parent().add_child(s)
			remove()
			
func on_contact(loc):
	pass

func _process(delta):
	if $MeshInstance.scale < Vector3(1,1,1):
		$MeshInstance.scale += Vector3(0.07,0.07,0.07)
	if active:
		translate(dir*speed)

func remove():
	parent.projectiles.remove(parent.projectiles.find(self))
	call_deferred("queue_free")

func on_activate():
	pass
