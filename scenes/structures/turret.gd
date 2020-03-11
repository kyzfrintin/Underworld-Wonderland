extends Spatial

export var track_factor = 0.2
var target
var active = false

func _process(delta):
	if !active: return
	look()
#	look_at(target.translation, Vector3(0,1,0))
	
func look():
	if (target == null): return
	if !active: return
	var loc = (target.global_transform.origin)
	get_node("../../").pos = loc
	var obj_scale : Vector3 = global_transform.basis.get_scale()
	var obj_loc : Vector3 = translation
	var target_transform: Transform = global_transform.looking_at(loc, Vector3(0,1,0))
	target_transform.basis = target_transform.basis.scaled(obj_scale)
	transform = transform.interpolate_with(target_transform, track_factor)
	translation = obj_loc

func killed():
	active = false
