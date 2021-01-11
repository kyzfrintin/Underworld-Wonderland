extends Control


func _ready():
	$Middle/Divide/Menu/Play.grab_focus()
	music.danger = 0

func _on_Play_pressed():
	get_tree().change_scene_to(preload("res://scenes/pages and worlds/main.tscn"))
	
func _on_Quit_pressed():
	get_tree().quit()
