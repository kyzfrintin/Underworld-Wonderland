extends Spatial

export var enabled = true
export var max_allocation = 75
export var max_per_spawn = 7
export var diff_level_interval = 30

var diff = 1.0
var allocated = 0

onready var base = preload("res://scenes/enemies/enemy_container.tscn")
onready var game = get_node("../")
onready var player = game.get_node("player")
onready var nav = game.get_node("Navigation")
onready var root = game.get_node("Enemies")
onready var pool = get_node("EnemyPool")

func _ready():
	if !enabled: return
	$countdown.start(rand_range(6,14))
	$diff_countdown.start(diff_level_interval)

func place(loc):
	randomize()
	var list = pool.get_resource_list()
	var enem = base.instance()
	enem.type = pool.get_resource(list[randi() % list.size()])
	var ranger = loc + Vector3(rand_range(-200,200),rand_range(-200,200),rand_range(-200,200))
	ranger = nav.get_closest_point(ranger)
	enem.translate(ranger)
	call_deferred("add", enem)

func add(enem):
	root.add_child(enem)
	allocated += enem.agent.allocation

func spawn_enemies():
	if allocated < max_allocation:
		var num
		if allocated < (max_allocation - max_per_spawn):
			num = randi() % max_per_spawn
		else:
			num = randi() % (allocated - max_allocation)
		var ppos = player.global_transform.origin
		for i in num:
			place(ppos)
	$countdown.start(rand_range((8/diff),(18/diff)))

func increase_difficulty():
	diff += 0.1
	game.get_node("UI/Main/TopRight/GameStats/Diff").text = ("Difficulty Scale: " + str(diff))
	max_allocation += int(round(rand_range(0,(5 * diff))))
	max_per_spawn += int(round(rand_range(0,(2 * diff))))
	diff_level_interval *= 0.9
	$diff_countdown.start(diff_level_interval)

func count_enemies():
	game.get_node("UI/Main/TopRight/GameStats/Enemies").text = ("Enemies: " + str(allocated))
	$recount_enemies.start()
