extends Node

onready var parent = get_node("../../")

func enter():
	parent.dead = true
	parent.on_death()
	parent.get_node("body").disabled = true
	parent.manager.allocated -= parent.allocation
	parent.anim.play("die")
	parent.anim.playback_speed = 1.0
	parent.game.danger -= parent.allocation
	parent.emit_signal("death", parent.max_health *0.09)
	parent.get_node("states").queue_free()
	parent.reacq.queue_free()
	parent.detect.queue_free()
	
func update():
	pass
	
func exit():
	pass
