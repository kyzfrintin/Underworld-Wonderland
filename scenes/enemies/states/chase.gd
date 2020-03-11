extends Node

onready var parent = get_node("../../")

func enter():
	parent.agent.anim.play("walk")
	parent.agent.reacq.connect("timeout", self, "reacquire")
	parent.agent.reacq.start(parent.agent.reacquire_speed)
	path_to_player()
	parent.agent.anim.playback_speed = 5.0
	parent.speed = parent.agent.attack_speed

func update():
	check_dead()
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])

func check_dead():
	if parent.player_dead:
		parent.restate("idle")
		parent.agent.reacq.stop()
	return parent.player_dead

func reacquire():
	if check_dead(): return
	var ppos = parent.game.get_node("player").global_transform.origin
	var dis = parent.global_transform.origin.distance_to(ppos)
	if dis > parent.agent.max_attack_range:
		path_to_player()
		parent.agent.anim.play("walk")
		parent.agent.reacq.start(parent.agent.reacquire_speed)
	else:
		parent.restate("ready_attack")
		parent.get_node("states/ready_attack").dis = dis

func path_to_player():
	var cpos : Vector3 = parent.global_transform.origin
	var ppos : Vector3 = parent.player.global_transform.origin
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = cpos.direction_to(ppos)
	if dis > parent.agent.max_attack_range:
		var pos = cpos + (dir * (dis - (parent.agent.max_attack_range * 0.75)))
		pos = parent.nav.get_closest_point(pos)
		parent.get_path_to(pos)

func exit():
	parent.agent.reacq.disconnect("timeout", self, "reacquire")
