extends Node

onready var parent = get_node("../../")
var in_sight = false

func enter():
	parent.sightline.enabled = true
	parent.reacq.connect("timeout", self, "reacquire")
	if parent.reacq.is_connected("timeout", parent, "acquire"):
		parent.reacq.disconnect("timeout", parent, "acquire")
	parent.anim.playback_speed = 1.3
	reacquire()
	parent.anim.play("walk")

func update():
	if check_dead(): return
	in_sight = parent.can_see_target()
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])

func check_dead():
	if parent.target == null:
		parent.restate("idle")
		parent.reacq.stop()
	return parent.target == null

func reacquire():
	if check_dead(): return
	var ppos = parent.target.global_transform.origin
	var dis = parent.global_transform.origin.distance_to(ppos)
	if dis > parent.max_attack_range:
		keep_chasing()
	else:
		if in_sight:
			parent.restate("ready_attack")
			parent.get_node("states/ready_attack").dis = dis
		else:
			print(parent.name + " can't see target")
			keep_chasing()

func keep_chasing():
	path_to_target()
	parent.anim.play("walk")
	parent.reacq.start(parent.reacquire_speed)

func path_to_target():
	var cpos : Vector3 = parent.global_transform.origin
	var ppos : Vector3 = parent.target.global_transform.origin
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	var pos
	if dis > (parent.max_attack_range * 0.5):
		pos = cpos + (dir * (dis - (rand_range(25,75))))
	elif dis > parent.max_attack_range:
		pos = cpos + (dir * (dis - (parent.max_attack_range * 0.75)))
	parent.get_path_to(pos)

func exit():
	parent.reacq.disconnect("timeout", self, "reacquire")
