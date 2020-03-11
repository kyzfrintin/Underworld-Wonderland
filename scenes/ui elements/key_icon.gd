tool
extends TextureRect

export (String) var key = "E" setget key_changed
export (float) var scale = 1.0 setget scale_changed

func key_changed(value):
	key = value
	$Label.text = key

func scale_changed(value):
	scale = value
	$Label.get("custom_fonts/font").size = 32*scale
