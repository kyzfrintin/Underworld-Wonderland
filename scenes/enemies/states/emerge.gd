extends Node

onready var parent = get_node("../../")

func enter():
	parent.agent.anim.play("emerge")
	
func update():
	pass
	
func exit():
	pass
