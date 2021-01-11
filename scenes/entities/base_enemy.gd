extends base_entity

class_name base_enemy

func init():
	friendly = false
#	player.connect("death", self, "player_killed")
	connect("death", player, "enemy_killed")
	restate("emerge")

func awake():
	manager.allocated += allocation
	game.danger += allocation

func target_killed(xp):
	if dead: return
	reacq.stop()
	target_dead = true
	restate("roam")
