extends Spatial

export var enabled = true
export var root_path : NodePath
export (int) var max_num = 50
export (float) var min_height = 0
export (float) var max_height = 1
export (float) var spawn_range = 4500

onready var pool = $Pool
onready var nav = get_node("../World/Navigation")

var root

func _ready():
	if !enabled: return
	root = get_node(root_path)
	randomize()
	var n = floor(rand_range(max_num * 0.5, max_num))
	for i in n:
		var list = pool.get_resource_list()
		var item = pool.get_resource(list[randi() % list.size()]).instance()
		var ran_pos = nav.get_closest_point(Vector3(rand_range(-spawn_range,spawn_range),350,rand_range(-spawn_range,spawn_range)))
		root.add_child(item)
		item.global_transform.origin = ran_pos + Vector3(0,rand_range(min_height,max_height),0)
