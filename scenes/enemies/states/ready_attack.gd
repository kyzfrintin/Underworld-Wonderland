extends Node

onready var parent = get_node("../../")
var dis
var target_pos

func enter():
	target_pos = parent.player.global_transform.origin
	parent.target_loc = target_pos
	parent.face_target()
	parent.anim.play("idle")

func track_attack():
	track_dis()
	var a = decide_attack(dis)
	parent.attack_state = a
	if a[1]:
		parent.restate("attack")

func decide_attack(dis):
	var attacks : Dictionary = parent.attack_dict
	var list = attacks.values()
	if !list.size() > 1:
		return [list[0].animation, parent.attack_enabled_array[0], 0]
	var a : String
	var d = parent.max_attack_range + 1
	var can_attack
	var num
	for i in list:
		if i.a_range > dis and i.a_range < d:
			d = i.a_range
			num = list.find(i)
			a = i.get("animation")
			parent.track_int = i.get("track_int")
			can_attack = parent.attack_enabled_array[num]
	return [a, can_attack, num]

func track_dis():
	dis = parent.global_transform.origin.distance_to(parent.player.translation)
	
func update():
	track_attack()
	if dis > parent.max_attack_range:
		parent.restate("chase")

func exit():
	pass
