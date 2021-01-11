extends Spatial

func _process(delta):
	$DirectionalLight.rotate_y(0.001)
	$Camera.rotate_y(0.001)
