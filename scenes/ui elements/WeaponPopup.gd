extends Spatial

var wep_stats = {}

func _ready():
	$Popup.texture = $Viewport.get_texture()

func set_scale(num):
	$Popup.scale = Vector3(num,num,num)
	
func update_info(price):
	$Viewport/ColorRect/Name.text = wep_stats["name"]
	$Viewport/ColorRect/Split/Stats/Icon.texture = wep_stats["icon"]
	$Viewport/ColorRect/Split/Stats/PDam.text = ("PRIMARY DAMAGE: %s" % wep_stats["damage_1"])
	$Viewport/ColorRect/Split/Stats/Rate.text = ("RATE: %s" % wep_stats["rate"])
	$Viewport/ColorRect/Split/Stats/SDam.text = ("SECONDARY DAMAGE: %s" % wep_stats["damage_2"])
	$Viewport/ColorRect/Split/Stats/Cooldown.text = ("SECONDARY COOLDOWN: %s" % wep_stats["cooldown"])
	$Viewport/ColorRect/Split/Stats/Price.text = ("PRICE: %s" % price)
