extends Node

var target_pos
onready var parent = get_node("../../")

func enter():
	target_pos = parent.player.global_transform.origin
	parent.target_loc = target_pos
	parent.face_target()
	var dis = parent.agent.global_transform.origin.distance_to(target_pos)
	if dis > parent.agent.max_attack_range:
		parent.restate("chase")
	var attack : Array = parent.attack_state
	parent.agent.current_attack = attack[0]
	if attack[1]:
		parent.agent.anim.play(attack[0])
		parent.agent.anim.playback_speed = 1
		get_child(attack[2]).start()
		parent.attack_enabled_array[attack[2]] = false
	else:
		parent.restate("ready_attack")
	
func update():
	pass
	
func exit():
	parent.agent.retarget.start(parent.agent.track_int)
