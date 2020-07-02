extends KinematicBody

var friendly = false
onready var true_pos = get_node("../diamond/trupos")

signal death

func hit(amnt, loc, nrml):
	get_node("../../").hit(amnt,loc,nrml)
