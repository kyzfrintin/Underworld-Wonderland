extends pickup

func get_info():
	popup.stats = {
		"name": item.item_name,
		"icon": item.icon,
		"desc": item.description
		}
	price = int(round(50 * (game.get_node("EnemySpawner").diff * 0.5)))
	
func get_input():
	if Input.is_action_just_pressed("gp_interact"):
		if player.cash >= price:
			item.pick_up(player)
			$buy.play()
			buy()

