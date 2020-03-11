extends CanvasLayer

onready var menu = load("res://scenes/pages and worlds/Menu.tscn")

onready var game = get_parent()
onready var stats_panel = $Main/StatsCorner
onready var crosshair = $Main/MidScreen/crosshair
onready var pause_menu = $Main/MidScreen/pause
onready var death_menu = $Main/MidScreen/retry
onready var weapons_panel = $Main/BottomPanel

var seconds : int = 0
var minutes : int = 0

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$Timer.paused = true
	crosshair.hide()
	weapons_panel.hide()
	pause_menu.show()
	pause_menu.grab_focus()
	
func died():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	crosshair.hide()
	weapons_panel.hide()
	death_menu.show()
	death_menu.grab_focus()

func resume():
	get_tree().paused = false
	$Timer.paused = false
	pause_menu.hide()
	weapons_panel.show()
	crosshair.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func restart():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func quit():
	get_tree().paused = false
	get_tree().change_scene_to(menu)


func add_second():
	seconds += 1
	if seconds == 60:
		minutes += 1
		seconds = 0
	$Main/TopRight/GameStats/Time.text = ("Time: " + str(minutes) + "m " + str(seconds) + "s")
	$Timer.start()
