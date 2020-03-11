extends KinematicBody

class_name base_enemy

#stats
export var health = 200
export var allocation = 1
export var roam_speed = 18
export var turn_rate = 10
export var attack_speed = 30
export var attack_interval = 1.0
export var max_attack_range = 150
export var reacquire_speed = 0.2
export var track_time = 0.3
export var idle_track = 0.5
export var track_int = 0.5
export var attack_dict : Dictionary = {
	"blank_attack": {
		"a_range": 10,
		"damage": 10,
		"animation": "anim",
		"track_int": 0.1,
		"cooldown": 1
		}
	}

var friendly = false
var current_attack : String
var dead = false
var health_pos : Vector2

onready var dnum_res = preload("res://scenes/ui elements/DamageNum2D.tscn")
onready var parent = get_node("../")
onready var game = get_node("../../../")
onready var manager = game.get_node("EnemySpawner")
onready var anim = $AnimationPlayer
onready var reacq = $reacquire
onready var detect = $detect
onready var retarget = $retarget

func hit(amnt, loc, nrml):
	parent.damage(amnt,loc,nrml)
	$HealthBar.wake()
	$HealthBar.value = parent.hp
	spawn_damage_number(amnt)
	if parent.hp <= 0:
		die()

func spawn_damage_number(num):
	var dnum = dnum_res.instance()
	dnum.wake(num, $HealthPoint.global_transform.origin, get_viewport())
	call_deferred("add_child", dnum)

func die():
	if dead: return
	dead = true
	$AnimationPlayer.stop()
	on_death()
	$CollisionShape.call_deferred("queue_free")
	parent.restate("die")
	manager.allocated -= allocation

func attack_over():
	on_end_attack()
	if parent.player_dead:
		parent.restate("idle")
	else:
		parent.restate("chase")

func delete():
	parent.call_deferred("queue_free")

func spawned():
	parent.restate("idle")
	$HealthBar.max_value = health
	$HealthBar.value = health

func _process(delta):
	$HealthBar.point = $HealthPoint.global_transform.origin

func on_death():
	pass

func on_end_attack():
	pass
