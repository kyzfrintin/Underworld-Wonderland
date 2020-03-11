extends Node

onready var parent = get_node("../../")

func enter():
	parent.agent.anim.play("idle")
	yield(get_tree().create_timer(rand_range(1,3)), "timeout")
	parent.restate("roam")
	
func update():
	pass
	
func exit():
	pass
