extends Node

onready var parent = get_node("../../")
var in_sight = false

func enter():
	parent.anim.play("walk")
	parent.sightline.enabled = true
	parent.reacq.connect("timeout", self, "reacquire")
	parent.reacq.start(parent.reacquire_speed)
	parent.player_pos = parent.translation
	path_to_player()
	parent.anim.playback_speed = 5.0

func update():
	check_dead()
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])
	in_sight = parent.can_see_player()
	if in_sight:
		if !parent.player_dead:
			var ppos = parent.player.global_transform.origin
			if parent.player_pos.distance_to(ppos) > (parent.track_speed * 1.5):
				parent.player_pos += (parent.player_pos.direction_to(ppos) * parent.track_speed)

func check_dead():
	if parent.player_dead:
		parent.restate("idle")
		parent.reacq.stop()
	return parent.player_dead

func reacquire():
	if check_dead(): return
	var ppos = parent.player.global_transform.origin
	var dis = parent.global_transform.origin.distance_to(ppos)
	if dis > parent.max_attack_range:
		keep_chasing()
	else:
		if in_sight:
			parent.restate("ready_attack")
			parent.get_node("states/ready_attack").dis = dis
		else:
			keep_chasing()

func keep_chasing():
	path_to_player()
	parent.anim.play("walk")
	parent.reacq.start(parent.reacquire_speed)

func path_to_player():
	var cpos : Vector3 = parent.global_transform.origin
	var ppos : Vector3 = parent.player.global_transform.origin
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	var pos
	if dis > parent.max_attack_range:
		pos = cpos + (dir * (dis - (parent.max_attack_range * 0.75)))
	else:
		pos = cpos + (dir * (dis - (rand_range(25,75))))
	parent.get_path_to(pos)

func exit():
	parent.reacq.disconnect("timeout", self, "reacquire")
