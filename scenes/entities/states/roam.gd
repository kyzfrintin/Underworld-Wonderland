extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("walk")
	parent.anim.playback_speed = 1.0
	parent.get_path_to()
	parent.reacq.start(parent.reacquire_speed)
	
func update():
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])
	else:
		parent.restate("idle")

func exit():
	pass

