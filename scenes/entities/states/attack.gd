extends Node

var target_pos
onready var parent = get_node("../../")

func enter():
	target_pos = parent.target.true_pos.global_transform.origin
	parent.target_loc = target_pos
#	parent.face_target()
	var dis = parent.global_transform.origin.distance_to(target_pos)
	if dis > parent.max_attack_range:
		parent.restate("chase")
	var attack : Array = parent.attack_state
	parent.current_attack = attack[0]
	if attack[1]:
		parent.anim.play(attack[0])
		parent.anim.playback_speed = 1
		get_child(attack[2]).start()
		parent.attack_enabled_array[attack[2]] = false
	else:
		parent.restate("ready_attack")
	
func update():
	pass
	
func exit():
	parent.retarget.start(parent.track_int)
