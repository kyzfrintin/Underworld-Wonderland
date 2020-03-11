extends ProgressBar

var point
var pos

func wake():
	modulate.a = 1

func _process(delta):
	if modulate.a > 0:
		modulate.a *= 0.99
	pos = get_viewport().get_camera().unproject_position(point)
	rect_position = pos - Vector2(rect_size.x / 2, 0)
