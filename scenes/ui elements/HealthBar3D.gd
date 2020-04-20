extends Sprite3D

func _ready():
	texture = $Viewport.get_texture()

func recharged():
	$recharged.play()

func set_max(amnt):
	$Viewport/ProgressBar.max_value = amnt

func set_percent(amnt):
	$Viewport/ProgressBar.value = amnt
