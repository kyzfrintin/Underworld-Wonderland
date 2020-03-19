extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("idle")
	parent.sightline.enabled = false
	yield(get_tree().create_timer(rand_range(1,3)), "timeout")
	parent.restate("roam")
	
func update():
	pass
	
func exit():
	pass
