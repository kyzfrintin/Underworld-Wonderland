extends Spatial

onready var player = get_node("player")
onready var nav = get_node("World/Navigation")
onready var proj = get_node("Projectiles")
onready var wep = load("res://scenes/items/weapon_spawner.tscn")
onready var enhance = load("res://scenes/items/enhancement_spawner.tscn")

export var randomise_spawn = true
export var random_range = 3000
export var height = 500

var danger = 0.0 setget danger_changed

func _ready():
	Engine.time_scale = 1
	music.danger = 0
#	music.get_node("main_playlist").connect("beat", self, "beat")
	if randomise_spawn:
		random_spawn()

func beat(beat):
	print($Allies/ziggurat.state)

func danger_changed(value):
	danger = value
	var d = (int((value / 15) * 6))
	music.set("danger", d)

func random_spawn():
	randomize()
	var ran_pos = nav.get_closest_point(Vector3(rand_range(-random_range,random_range),rand_range(-random_range,random_range),rand_range(-random_range,random_range)))
	player.global_transform.origin = ran_pos + Vector3(0,100,0)

func _process(delta):
	$UI/Main/TopRight/GameStats/FPSLabel.text = ("FPS: " + str(Engine.get_frames_per_second()))
	if Input.is_key_pressed(KEY_G):
		$EnemySpawner.spawn_enemies()

func died(stats):
	var ccam = get_viewport().get_camera()
	var cam = ccam.duplicate()
	cam.global_transform = ccam.global_transform
	add_child(cam)
	call_deferred("remove_parts")
	Engine.time_scale = 0.3
	$UI.died(stats)
	
func remove_parts():
	player.queue_free()
	$World/EnemySpawner.queue_free()
