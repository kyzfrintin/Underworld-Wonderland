extends enhancement

class_name buff_item

export(String) var property
export(float) var amount

func on_pick_up(player):
	var p = player.get(property)
	player.set(property, (p + (p * amount)))
	pass
