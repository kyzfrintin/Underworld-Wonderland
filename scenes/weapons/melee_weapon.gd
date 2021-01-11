extends weapon

class_name melee_weapon

export (NodePath) var hurt_box
var holster : Vector3

func on_equip():
	holster = translation
	parent.get_node("Camera/RayCast").add_exception(get_node(hurt_box))
	parent.get_node("Controller/InnerGimbal/Camera/RayCast").add_exception(get_node(hurt_box))

func attack():
	if right_hand:
		$AnimationPlayer.play("prim_right")
	else:
		$AnimationPlayer.play("prim_left")

func melee_attack():
	var col = get_node(hurt_box).get_overlapping_areas() + get_node(hurt_box).get_overlapping_bodies()
	var loc = get_node(hurt_box).global_transform.origin
	var nrm = get_node(hurt_box).global_transform.origin
	for i in col:
		if i.has_method("hit"):
			i.hit(primary_damage, loc, nrm, parent)
			contact()

func contact():
	pass
