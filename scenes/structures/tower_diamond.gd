extends KinematicBody

var friendly = false

func hit(amnt, loc, nrml):
	get_node("../../").hit(amnt,loc,nrml)
