extends Spatial


onready var pool = $WeaponList
onready var popup = $popup_pivot/WeaponPopup
onready var game = get_node("../../")

var inside = false
var player
var weapon
var wep_name
var spin = false
var spin_factor = 0.01
var price: int

func _ready():
	randomize()
	var list = pool.get_resource_list()
	var num = randi() % list.size()
	weapon = pool.get_resource(list[num]).instance()
	wep_name = list[num]
	var icon = Sprite3D.new()
	icon.texture = weapon.icon
	icon.scale = Vector3(8,8,8)
	$weapon.add_child(icon)
	popup.wep_stats = {
		"name": wep_name,
		"icon": weapon.icon,
		"damage_1": weapon.primary_damage,
		"damage_2": weapon.secondary_damage,
		"rate": weapon.rate,
		"cooldown": weapon.secondary_cooldown,
		}
	update_info()
	
func update_info():
	price = int(round(((weapon.primary_damage/weapon.rate) + ((weapon.secondary_damage/weapon.secondary_cooldown) * 0.8)) * (game.get_node("EnemySpawner").diff * 0.75)))
	popup.update_info(price)

func enter(body):
	if body.name == "player":
		if !inside:
			update_info()
			if body.get_node("Controller").first_person:
				popup.set_scale(0.4)
				popup.translation.y = 1
			else:
				popup.set_scale(1)
				popup.translation.y = 5
			popup.show()
			inside = true
			player = body
			player.in_wep_bubble = true

func _process(_delta):
	if spin:
		$weapon.rotation += Vector3(0,spin_factor,0)
		spin_factor += 0.01
	if !inside: return
	$popup_pivot.look_at(player.translation + Vector3(0,3,0), Vector3(0,1,0))
	if Input.is_action_just_pressed("gp_right_hand_second_attack"):
		if player.cash >= price:
			var wep = weapon
			player.replace_weapon(true, wep)
			player.cash -= price
			player.update_exp()
			$AnimationPlayer.play("pickup")
	if Input.is_action_just_pressed("gp_left_hand_second_attack"):
		if player.cash >= price:
			var wep = weapon
			player.replace_weapon(false, wep)
			player.cash -= price
			player.update_exp()
			$AnimationPlayer.play("pickup")

func remove():
	call_deferred("queue_free")

func begin_delete():
	spin = true
	player.in_wep_bubble = false 
	$popup_pivot.hide()
	$Area.call_deferred("queue_free")

func exited(body):
	if body.name == "player":
		if inside:
			popup.hide()
			inside = false
			player.in_wep_bubble = false
			player = null
