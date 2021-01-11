extends base_entity

#onready var beam = $body/Armature/Barrel/beam
onready var turret = $body/turret
onready var t_spawn = $body/turret/bomb_spawn
onready var project = preload("res://scenes/projectiles/rail_proj.tscn")

var projectiles = []

func init():
	global_transform.origin = nav_spot(global_transform.origin)
	friendly = true
	leader = player
	restate("emerge")

func awake():
	begin_fly()
	
#func on_change():
#	print(name + ' changing to ' + state)

func ready_shot():
	var t_pos = target_pos
#	face_target(t_pos)
#	var loc = beam.global_transform.origin

func _process(delta):
	if target:
		turret.look_at(target_pos, Vector3(0,1,0))
		
func shot():
#	print('zigurrat shot ' + col.name)
	spawn_proj()
			
#	cast.enabled = false
#	beam.hide()

func on_death():
	$fly_tween.interpolate_property($body, "translation", $body.translation, Vector3(0,0,0), 0.9, Tween.TRANS_EXPO, Tween.EASE_IN)
	$fly_tween.start()

func spawn_proj():
	var point = t_spawn.global_transform.origin
	var p = project.instance()
	p.translation = point
	p.parent = self
	p.friendly = false
	p.entity = self
	p.damage = attack_dict["basic_shot"]["damage"]
	p.get_node("spawn_sound").spawn_node = self
	p.dir = point.direction_to(target_pos)
	game.proj.add_child(p)
	projectiles.append(p)

func begin_fly():
	if dead: return
	$fly_tween.interpolate_property($body, "translation", $body.translation, Vector3(rand_range(-10,10),rand_range(15,25), 0), rand_range(2,6), Tween.TRANS_EXPO, Tween.EASE_IN)
	$fly_tween.start()

func fly_end(object, key):
	begin_fly()
	
func on_kill(xp):
	target_dead = true
	target = null
#	detect.monitoring = true
	restate("follow")
#	reacq.start(reacquire_speed)
	leader.enemy_killed(xp)
