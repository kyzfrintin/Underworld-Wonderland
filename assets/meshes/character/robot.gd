extends Spatial


func freeze_toggle():
	var p = get_node("../../Controller")
	if p.freeze:
		p.freeze = false
	else:
		p.freeze = true
		
	
