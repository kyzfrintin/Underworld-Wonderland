extends Spatial

onready var player = get_node("player")
onready var nav = get_node("Navigation")
onready var proj = get_node("Projectiles")
onready var wep = load("res://scenes/items/weapon_spawner.tscn")
onready var enhance = load("res://scenes/items/enhancement_spawner.tscn")

func _ready():
	Engine.time_scale = 1
	randomize()
#	var ran_pos = nav.get_closest_point(Vector3(rand_range(-2700,2700),100,rand_range(-2700,2700)))
#	player.global_transform.origin = ran_pos + Vector3(0,5,0)
	place_weapon_pickups()
	place_enhance_pickups()

func place_weapon_pickups():
	var num = 25 + randi() % 25
	for i in num:
		var wepup = wep.instance()
		var ran_pos = nav.get_closest_point(Vector3(rand_range(-2700,2700),100,rand_range(-2700,2700)))
		wepup.translate(Vector3(ran_pos.x, ran_pos.y + 3, ran_pos.z))
		$Items.add_child(wepup)

func place_enhance_pickups():
	var num = 25 + randi() % 25
	for i in num:
		var enhanceup = enhance.instance()
		var ran_pos = nav.get_closest_point(Vector3(rand_range(-2700,2700),100,rand_range(-2700,2700)))
		enhanceup.translate(Vector3(ran_pos.x, ran_pos.y + 3, ran_pos.z))
		$Items.add_child(enhanceup)

func _process(delta):
	$UI/Main/TopRight/GameStats/FPSLabel.text = ("FPS: " + str(Engine.get_frames_per_second()))

func died():
	var ccam = get_viewport().get_camera()
	var cam = ccam.duplicate()
	cam.global_transform = ccam.global_transform
	add_child(cam)
	call_deferred("remove_parts")
	Engine.time_scale = 0.3
	$UI.died()
	
func remove_parts():
	player.queue_free()
	$EnemySpawner.queue_free()
