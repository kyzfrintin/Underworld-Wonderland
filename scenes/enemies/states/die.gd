extends Node

onready var parent = get_node("../../")

func enter():
	parent.agent.anim.play("die")
	parent.agent.anim.playback_speed = 1.0
	parent.emit_signal("death", parent.agent.health *0.06)
	
func update():
	pass
	
func exit():
	pass
