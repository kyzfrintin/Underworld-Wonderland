extends KinematicBody

class_name enemy_ai

var path : PoolVector3Array setget path_changed
var state = "emerge"
var target_loc = Vector3()
var player_dead = false
var attack_enabled_array = []
var attack_state = []

onready var game = get_node("../../")
onready var nav = get_node("../../Navigation")
onready var player = get_node("../../player")

signal death

func _ready():
	hp = t.health
	agent = t
	agent.retarget.connect("timeout", self, "face_target")
	generate_attack_array()
	player.connect("death", self, "player_killed")
	connect("death", player, "enemy_killed")
	restate("emerge")
	global_transform.origin = nav.get_closest_point(global_transform.origin)


