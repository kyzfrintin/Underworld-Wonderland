extends Node

class_name enhancement

export(String) var item_name
export(String) var description
export(Texture) var icon

func pick_up(player):
	var new = self.duplicate()
	player.get_node("items").add_child(new)
	on_pick_up(player)

func on_pick_up(player):
	pass
