extends Spatial

var hp = 750
var active = false
var offset = 1
var spos
var rumble = false
var dist : float
var pos = Vector3()

onready var detect = $detect
onready var turret = $body/turret
onready var ray = $body/turret/RayCast
onready var bp = $body/turret/beam_point

signal destroyed

func _ready():
	$body/HealthBar3D.set_max(hp)
	$body/HealthBar3D.set_percent(hp)
	ray.add_exception($body/diamond_body)

func on_enter(body : Object):
	if body.get("friendly") != null:
		if body.friendly:
			$AnimationPlayer.play("rise")
			turret.target = body
			$detect.queue_free()
			body.connect("death", self, "killed")
			connect("destroyed", body, "enemy_killed")

func hit(amnt, loc, nrml):
	hp -= amnt
	$body/HealthBar3D.set_percent(hp)
	if hp <= 0:
		die()

func die():
	active = false
	$beamparticles.visible = false
	$beamparticles/sear.stop()
	$body/diamond_body.call_deferred("queue_free")
	$AnimationPlayer.playback_speed = 0.7
	$AnimationPlayer.play("die")

func send_xp():
	emit_signal("destroyed", 75)

func _process(delta):
	if active:
		var cast_point = ray.get_collision_point()
		var dis = bp.global_transform.origin.distance_to(cast_point)
		dist = dis
		bp.scale.z = dis/4
		$beamparticles.global_transform.origin = cast_point
		var col = ray.get_collider()
		if !col: return
		if col.has_method("hit"):
			col.hit(0.25, cast_point, ray.get_collision_normal())
				
	if rumble:
		var rpos = Vector3(rand_range(-offset,offset),rand_range(-offset,offset),rand_range(-offset,offset))
		global_transform.origin = spos + rpos
		offset += 0.02

func killed():
	get_node("body/turret").killed()
	active = false

func begin_rumble():
	rumble = true

func activate():
	spos = global_transform.origin
	turret.active = true
	ray.enabled = true
	active = true
	$hum.play()
	$hum2.play()
	$body/HealthBar3D.show()
	$beamparticles.visible = true
	$beamparticles/sear.play()
	$AnimationPlayer.play("cubeanim")
