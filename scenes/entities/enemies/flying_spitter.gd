extends base_enemy

onready var fireball_res = load("res://scenes/projectiles/fireball.tscn")
var projectiles : Array = []

func _ready():
	begin_fly()
	
func launch_fireball():
	var point = $body/fb_point.global_transform.origin
	var fb = fireball_res.instance()
	fb.translation = point
	fb.parent = self
	fb.friendly = false
	fb.entity = self
	fb.damage = attack_dict["launch_fb"]["damage"]
	fb.get_node("spawn_sound").spawn_node = self
	fb.dir = point.direction_to(target_pos)
	game.proj.add_child(fb)
	projectiles.append(fb)

func begin_fly():
	$fly_tween.interpolate_property($body, "translation", $body.translation, Vector3(rand_range(-20,20),rand_range(20,80), 0), rand_range(2,6), Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$fly_tween.start()

func fly_end(object, key):
	begin_fly()
	
func on_death():
	$fly_tween.stop_all()
	for i in projectiles:
		i.call_deferred("queue_free")
