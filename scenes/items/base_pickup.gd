extends Spatial

class_name pickup

export(NodePath) var pool_path
export(NodePath) var popup_path

var pool
var popup
var inside = false
var player
var spin = false
var spin_factor = 0.01
var price: int
var item
var item_name

onready var game = get_node("../../")

func _ready():
	randomize()
	pool = get_node(pool_path)
	popup = get_node(popup_path)
	var list = pool.get_resource_list()
	var num = randi() % list.size()
	item = pool.get_resource(list[num]).instance()
	item_name = list[num]
	var icon = Sprite3D.new()
	icon.texture = item.icon
	icon.scale = Vector3(8,8,8)
	$item.add_child(icon)
	update_info()
	
func update_info():
	get_info()
	popup.update_info(price)

func get_info():
	pass

func enter(body):
	if body.name == "player":
		if !inside:
			$enter.play()
			update_info()
			if body.get_node("Controller").first_person:
				popup.set_scale(0.4)
				popup.translation.y = 0
			else:
				popup.set_scale(1)
				popup.translation.y = 3
			popup.show()
			inside = true
			player = body
			player.in_bubble = true

func _process(_delta):
	if spin:
		$item.rotation += Vector3(0,spin_factor,0)
		spin_factor += 0.01
	if !inside: return
	$popup_pivot.look_at(player.translation + Vector3(0,4,0), Vector3(0,1,0))
	get_input()

func get_input():
	pass

func remove():
	call_deferred("queue_free")

func begin_delete():
	spin = true
	player.in_bubble = false 
	$popup_pivot.hide()
	$Area.call_deferred("queue_free")

func exited(body):
	if body.name == "player":
		if inside:
			popup.hide()
			inside = false
			player.in_bubble = false
			player = null

func buy():
	player.cash -= price
	player.update_exp()
	$AnimationPlayer.play("pickup")
