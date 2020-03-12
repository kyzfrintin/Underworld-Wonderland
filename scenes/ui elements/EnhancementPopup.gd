extends Spatial

var stats = {}

func _ready():
	$Popup.texture = $Viewport.get_texture()

func set_scale(num):
	$Popup.scale = Vector3(num,num,num)
	
func update_info(price):
	$Viewport/ColorRect/Name.text = stats["name"]
	$Viewport/ColorRect/Split/Stats/Icon.texture = stats["icon"]
	$Viewport/ColorRect/Split/Stats/Desc.text = stats["desc"]
	$Viewport/ColorRect/Split/Stats/Price.text = ("PRICE: %s" % price)
	
