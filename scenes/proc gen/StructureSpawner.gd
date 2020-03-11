extends Spatial

export var enabled = true
export (int) var max_num = 50

onready var pool = $StructPool
onready var nav = get_node("../Navigation")
onready var root = get_node("../Structures")

func _ready():
	if !enabled: return
	randomize()
	var n = floor(rand_range(max_num * 0.5, max_num))
	for i in n:
		var list = pool.get_resource_list()
		var struct = pool.get_resource(list[randi() % list.size()]).instance()
		var ran_pos = nav.get_closest_point(Vector3(rand_range(-2700,2700),100,rand_range(-2700,2700)))
		root.add_child(struct)
		struct.global_transform.origin = ran_pos - Vector3(0,rand_range(10,30),0)
