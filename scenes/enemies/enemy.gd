extends Area

class_name base_enemy

#stats
export var max_health = 200
export var allocation = 1
export var roam_speed = 18
export var roam_range = 100
export var attack_speed = 30
export var max_attack_range = 150
export var reacquire_speed = 0.2
export var track_time = 0.3
export var track_int = 0.5
export var enem_name : String
export var attack_dict : Dictionary = {
	"blank_attack": {
		"a_range": 10,
		"damage": 10,
		"animation": "anim",
		"track_int": 0.1,
		"cooldown": 1
		}
	}

var health
var friendly = false
var current_attack : String
var dead = false
var health_pos : Vector2
var path : PoolVector3Array
var path_draw
var state = "emerge"
var target_loc = Vector3()
var player_pos = Vector3()
var track_speed : float = (attack_speed / 25)
var player_dead = false
var attack_enabled_array = []
var attack_state = []

onready var true_pos = get_node("body/TruePos")
onready var game = get_node("../../")
onready var nav = game.get_node("World/Navigation")
onready var player = get_node("../../player")

onready var dnum_res = preload("res://scenes/ui elements/DamageNum2D.tscn")
onready var manager = game.get_node("EnemySpawner")
onready var sightline = $body/sightline
onready var anim = $AnimationPlayer
onready var reacq = $reacquire
onready var detect = $detect
onready var retarget = $retarget

signal death
signal hit
signal spotted
signal hit_player

func _ready():
	health = max_health
	sightline.add_exception(detect)
	retarget.connect("timeout", self, "face_target")
	generate_attack_array()
	player.connect("death", self, "player_killed")
	connect("death", player, "enemy_killed")
	restate("emerge")
	global_transform.origin = nav_spot(global_transform.origin)

func hit(amnt, loc, nrml):
	health -= amnt
	$HealthBar.wake()
	$HealthBar.value = health
	spawn_damage_number(amnt)
	if (state == "idle") or (state == "roam"):
		restate("chase")
	if health <= 0:
		restate("die")

func generate_attack_array():
	var attacks : Dictionary = attack_dict
	var list = attacks.values()
	for i in list:
		var t = Timer.new()
		t.wait_time = i.get("cooldown")
		t.one_shot = true
		$states/attack.add_child(t)
		attack_enabled_array.append(true)
		t.connect("timeout", self, "attack_cooldown", [t.get_index()])

func get_path_to(pos=null):
	path.empty()
	var loc = global_transform.origin
	var spot
	if !pos:
		randomize()
		spot = Vector3(rand_range(loc.x-100,loc.x+100),
		rand_range(loc.y-100,loc.y+100),
		rand_range(loc.z-100,loc.z+100))
	else:
		spot = pos
	spot = nav_spot(spot)
	path = nav.get_simple_path(loc, spot)
	if path:
		path_updated()
	else:
		get_path_to()

func path_updated():
	target_loc = path[0]
	face_target()

func nav_spot(spot):
	return nav.get_closest_point(spot)

func move_to(loc):
	var cloc = translation
	if cloc.distance_to(path[0]) > 15:
		var s : float
		if state == "roam":
			s = roam_speed
		else:
			s = attack_speed
		var vec = cloc.direction_to(path[0]) * (0.01 * s)
		translation += vec
	else:
		path.remove(0)
		if path.size() > 0:
			path_updated()
	
func draw_path():
	path_draw.clear()
	path_draw.begin(Mesh.PRIMITIVE_LINE_STRIP)
	path_draw.set_color(Color(0,0,0))
	path_draw.add_vertex(translation)
	for i in path:
		path_draw.add_vertex(i)
	path_draw.end()
	
func face_target(loc=target_loc):
#	instant method
	if loc != target_loc:
		target_loc = loc
	$body.look_at(target_loc, Vector3(0,1,0))
#	tween method
#	var obj_scale: Vector3 = $body.global_transform.basis.get_scale()
#	var target_transform: Transform = $body.global_transform.looking_at(target_loc, Vector3(0,1,0))
#	target_transform.basis = target_transform.basis.scaled(obj_scale)
#	var trans = $body.transform.looking_at(target_loc, Vector3(0,1,0))
#	var rot = trans.basis.get_euler()
#	$turn.interpolate_property($body, "global_transform", $body.global_transform, target_transform, track_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$turn.start()
#	retarget.start(track_int)

func attack_cooldown(num):
	attack_enabled_array[num] = true
	
func spawn_damage_number(num):
	var dnum = dnum_res.instance()
	dnum.wake(num, $body/HealthPoint.global_transform.origin, get_viewport())
	call_deferred("add_child", dnum)

func attack_over():
	on_end_attack()
	if player_dead:
		restate("idle")
	else:
		restate("chase")

func delete():
	yield($VisibilityNotifier, "camera_exited")
	call_deferred("queue_free")

func spawned():
	restate("idle")
	manager.allocated += allocation
	game.danger += allocation
	$HealthBar.max_value = health
	$HealthBar.value = health

func can_see_player():
	var ppos = player.global_transform.origin
	sightline.look_at(ppos, Vector3(0,1,0))
	if sightline.is_colliding():
		var col = sightline.get_collider()
		if col.name == "player":
			return true
		else:
			return false
	else:
		return false

func player_killed():
	reacq.stop()
	player_dead = true
	restate("roam")
	
func restate(newstate):
	if state == newstate: return
	get_node("states/" + state).exit()
	get_node("states/" + newstate).enter()
	state = newstate

func _process(delta):
	get_node("states/" + state).update()
	$HealthBar.point = $body/HealthPoint.global_transform.origin

func entered(body):
	if body.has_method("hit") and body.friendly:
			collided_with_player(body)
			
func collided_with_player(col):
	pass

func on_death():
	pass

func on_end_attack():
	pass

func anim_finished(anim_name):
	if anim_name == "die":
		delete()


