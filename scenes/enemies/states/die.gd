extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("die")
	parent.anim.playback_speed = 1.0
	parent.emit_signal("death", parent.max_health *0.06)
	
func update():
	pass
	
func exit():
	pass
