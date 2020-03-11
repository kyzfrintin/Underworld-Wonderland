extends Label

var point : Vector3
var offset : Vector2 = Vector2(0,0)
var up = 0.0
var pos : Vector2
var active = false
var viewport

func wake(num, p, v):
	active = true
	viewport = v
	set_pos()
	point = p
	offset = Vector2(rand_range(-35,35),rand_range(-35,35))
	text = str(num)
	modulate.a = 1

func _process(delta):
	if !active: return
	up += 0.05
	offset.y -= up
	set_pos()
	if modulate.a > 0.05:
		modulate.a *= 0.97
	else:
		call_deferred("queue_free")

func set_pos():
	pos = viewport.get_camera().unproject_position(point)
	pos += offset
	rect_position = (pos - Vector2(rect_size.x / 2, 0))

func on_exit(viewport):
	call_deferred("queue_free")
