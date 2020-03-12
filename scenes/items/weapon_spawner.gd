extends pickup

func get_info():
	popup.wep_stats = {
		"name": item.wep_name,
		"icon": item.icon,
		"damage_1": item.primary_damage,
		"damage_2": item.secondary_damage,
		"rate": item.rate,
		"cooldown": item.secondary_cooldown,
		}
	price = int(round(((item.primary_damage/item.rate) + ((item.secondary_damage/item.secondary_cooldown) * 0.8)) * (game.get_node("EnemySpawner").diff * 0.75)))
	
func get_input():
	if Input.is_action_just_pressed("gp_right_hand_second_attack"):
		if player.cash >= price:
			var wep = item
			player.replace_weapon(true, wep)
			$buy.play()
			buy()
	if Input.is_action_just_pressed("gp_left_hand_second_attack"):
		if player.cash >= price:
			var wep = item
			player.replace_weapon(false, wep)
			$buy.play()
			buy()

