extends Node

onready var main = $main_playlist

var danger : int = 0
var d : float = 0

func _process(delta):
	d = lerp(d, danger, 0.02)
