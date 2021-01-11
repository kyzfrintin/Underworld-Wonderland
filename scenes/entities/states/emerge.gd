extends Node

onready var parent = get_node("../../")

func enter():
	parent.anim.play("emerge")
	
func update():
	pass
	
func exit():
	pass
