extends Spatial

export (PackedScene) var type
var hp
var speed = 12
var path : PoolVector3Array setget path_changed
var state = "emerge"
var agent
var target_loc = Vector3()
var player_dead = false
var attack_enabled_array = []
var attack_state = []

onready var game = get_node("../../")
onready var nav = get_node("../../Navigation")
onready var player = get_node("../../player")

signal death

func _ready():
	var t = type.instance()
	add_child(t)
	hp = t.health
	agent = t
	agent.retarget.connect("timeout", self, "face_target")
	generate_attack_array()
	player.connect("death", self, "player_killed")
	connect("death", player, "enemy_killed")
	restate("emerge")
	global_transform.origin = nav.get_closest_point(global_transform.origin)

func generate_attack_array():
	var attacks : Dictionary = agent.attack_dict
	var list = attacks.values()
	for i in list:
		var t = Timer.new()
		t.wait_time = i.get("cooldown")
		t.one_shot = true
		$states/attack.add_child(t)
		attack_enabled_array.append(true)
		t.connect("timeout", self, "attack_cooldown", [t.get_index()])

func attack_cooldown(num):
	attack_enabled_array[num] = true
	
func damage(amnt, loc, nrml):
	hp -= amnt
	if (state == "idle") or (state == "roam"):
		restate("chase")
	
func path_changed(value):
	path = value

func get_path_to(pos=null):
	var loc = global_transform.origin
	var spot
	if !pos:
		randomize()
		spot = Vector3(rand_range(loc.x-100,loc.x+100),
		rand_range(loc.y-100,loc.y+100),
		rand_range(loc.z-100,loc.z+100))
	else:
		spot = pos
	spot = nav.get_closest_point(spot)
	self.path = nav.get_simple_path(loc, spot)

func move_to(loc):
#	print("moving, " + str(path.size()) + " points left")
	var cloc = global_transform.origin
	if cloc.distance_to(path[0]) > 15:
		var vec = cloc.direction_to(path[0]) * (0.01 * speed)
		translate(vec)
	else:
		self.path.remove(0)
		
func face_target():
#	instant method
	agent.look_at(target_loc, Vector3(0,1,0))
#	tween method
#	var obj_scale: Vector3 = agent.global_transform.basis.get_scale()
#	var target_transform: Transform = agent.global_transform.looking_at(target_loc, Vector3(0,1,0))
#	target_transform.basis = target_transform.basis.scaled(obj_scale)
#	var trans = agent.transform.looking_at(target_loc, Vector3(0,1,0))
#	var rot = trans.basis.get_euler()
#	agent.turn.interpolate_property(agent, "global_transform", agent.global_transform, target_transform, agent.track_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	agent.turn.start()
	agent.retarget.start(agent.track_int)

func player_killed():
	agent.reacq.stop()
	player_dead = true
	restate("roam")
	
func restate(newstate):
	get_node("states/" + state).exit()
	get_node("states/" + newstate).enter()
	state = newstate

func _process(delta):
	get_node("states/" + state).update()
