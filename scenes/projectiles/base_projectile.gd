extends Area

class_name projectile

export (float) var speed
export (String, "Absorb", "AOE", "Timed", "Aura") var type = "Absorb"
export (PackedScene) var spawner

var destination
var parent
var dir
var active
var swarm
var friendly
var damage
var entity

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
	if $spawn_sound:
		$spawn_sound.play()
	on_activate()
	
func collide(body : Object):
	if !active: return
	if body is StaticBody:
		on_contact(translation)
		remove()
		if type == "AOE":
			aoe_spawn()
	if body.has_method("hit"):
		if body == entity: return
		on_contact(translation)
		match type:
			"Absorb":
				body.hit(damage, translation, body.global_transform.origin.direction_to(translation), entity)
			"AOE":
				aoe_spawn()
		remove()

func aoe_spawn():
	var s = spawner.instance()
	s.damage = damage
	s.global_transform.origin = global_transform.origin
	s.parent = entity
	s.entity = entity
	s.friendly = friendly
	get_parent().add_child(s)
			
func on_contact(loc):
	pass

func _process(delta):
	if swarm:
		if $MeshInstance.scale < Vector3(1,1,1):
			$MeshInstance.scale += Vector3(0.07,0.07,0.07)
	if active:
		translate(dir*speed)

func remove():
	if parent:
		parent.projectiles.remove(parent.projectiles.find(self))
	call_deferred("queue_free")

func on_activate():
	pass
