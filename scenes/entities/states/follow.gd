extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("walk")
	parent.anim.playback_speed = 1.0
	parent.reacq.start(parent.reacquire_speed)
	parent.get_path_to(get_spot_near_leader())
	
func update():
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])
	else:
		parent.restate("idle")

func get_spot_near_leader():
	var cpos : Vector3 = parent.global_transform.origin
	var ppos : Vector3 = parent.leader.global_transform.origin
	var dis : float = cpos.distance_to(ppos)
	var dir : Vector3 = ppos.direction_to(cpos)
	var pos
	if dis > parent.roam_range:
		pos = ppos + (dir * (20 + rand_range(0,50)))
	return ppos

func exit():
	pass
