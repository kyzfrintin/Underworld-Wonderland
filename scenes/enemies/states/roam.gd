extends Node

onready var parent = get_node("../../")

func enter():
	parent.agent.anim.play("walk")
	parent.agent.track_int = parent.agent.idle_track
	parent.agent.anim.playback_speed = 1.0
	parent.agent.reacq.connect("timeout", self, "acquire")
	parent.agent.reacq.start(1)
	parent.speed = parent.agent.roam_speed
	parent.get_path_to()
	
func update():
	if parent.path:
		parent.target_loc = parent.path[0]
		parent.move_to(parent.path[0])
	else:
		parent.restate("idle")

func exit():
	parent.agent.reacq.disconnect("timeout", self, "acquire")

func acquire():
	if !parent.agent.detect.monitoring: return
	var cols = parent.agent.detect.get_overlapping_bodies()
	if cols.size() > 0:
		for i in cols:
			if i.name == "player":
				parent.agent.reacq.stop()
				parent.agent.get_node("detect").monitoring = false
				parent.restate("chase")
	else:
		parent.agent.reacq.start(1)
