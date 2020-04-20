extends Sprite3D

var num

func _ready():
	translate(Vector3(rand_range(-15,15),rand_range(-15,15),rand_range(-15,15)))
	texture = $Viewport.get_texture()
	$Viewport/Label.text = str(num)

func set_scale(s):
	$Viewport.size *= s
	$Viewport/Label.rect_scale *= s

func _process(delta):
	translate(Vector3(0,3,0))
	if $Viewport/Label.modulate.a > 0:
		$Viewport/Label.modulate.a -= 0.02
	else:
		call_deferred("queue_free")
