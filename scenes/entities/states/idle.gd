extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("idle")
	parent.sightline.enabled = false
	if !parent.reacq.is_connected("timeout", parent, "acquire"):
		parent.reacq.connect("timeout", parent, "acquire")
	check_follow()
	
func check_follow():
	yield(get_tree().create_timer(rand_range(1,3)), "timeout")
	if parent.target != null: return
	if parent.leader != null:
		var dis = parent.global_transform.origin.distance_to(parent.leader.true_pos.global_transform.origin)
		if dis > parent.roam_range:
			parent.restate("follow")
		else:
			check_follow()
	else:
		parent.restate("roam")
	
func update():
	pass
	
func exit():
	pass
