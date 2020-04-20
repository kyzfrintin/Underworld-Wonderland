extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("walk")
	parent.anim.playback_speed = 1.0
	parent.reacq.connect("timeout", self, "acquire")
	parent.reacq.start(parent.reacquire_speed)
	parent.get_path_to()
	
func update():
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])
	else:
		parent.restate("idle")

func exit():
	pass
	parent.reacq.disconnect("timeout", self, "acquire")

func acquire():
	if !parent.detect.monitoring: return
	var cols = parent.detect.get_overlapping_bodies()
	if cols.size() > 0:
		for i in cols:
			if i.name == "player":
				parent.reacq.stop()
				parent.get_node("detect").monitoring = false
				parent.restate("chase")
	else:
		parent.reacq.start(parent.reacquire_speed)
