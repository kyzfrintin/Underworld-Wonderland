extends KinematicBody


#stats
var max_hp = 100 setget set_maxhp
var hp = 100
var speed_scale = 1.0
var jump_scale = 1.0
var damage_scale = 1.0
var cash_scale = 1.0
var attack_speed_scale = 1.0
var heal_amnt = 0.2
var level : int = 1 
var xp = 0.0 setget set_xp
var xp_threshold : int = 100
var cash : int = 25

var perf_stats : Dictionary = {
	"killed": 0
}

var friendly = true
var right_weapon
var left_weapon
var cast_point
var cast_to : Vector3
var healing = false setget set_healing
var can_heal = true
var in_bubble = false
var dead = false

onready var ray = get_node("Controller").get_node("InnerGimbal/Camera/RayCast")
onready var cam = get_node("Controller/InnerGimbal/Camera")
onready var cam_cast = get_node("Controller/InnerGimbal/RayCast")
onready var controller = $Controller
onready var r_mount = $WeaponMountR
onready var l_mount = $WeaponMountL
onready var body = $body_pivot/robot
onready var anim = body.get_node("AnimationTree")

onready var true_pos = $Chest
onready var game = get_parent()
onready var dnum_res = preload("res://scenes/ui elements/DamageNum2D.tscn")
onready var stats_ui = game.get_node("UI/Main/StatsCorner")
onready var wep_ui = game.get_node("UI/Main/BottomPanel/WeaponIcons")
onready var xpbar = stats_ui.get_node("XP/XPBar")
onready var xplabel = stats_ui.get_node("XP/XPBar/XPLabel")
onready var hpbar = stats_ui.get_node("Health/HPBar")
onready var hplabel = stats_ui.get_node("Health/HPBar/HPLabel")
onready var lev_label = stats_ui.get_node("XP/LevelLabel")
onready var cash_label = stats_ui.get_node("CashLabel")

signal death

func add_buff():
	pass

func set_healing(value):
	healing = value
	if value:
		hpbar.get_node("../heal_indicator").color = Color(0,1,0)
	else:
		hpbar.get_node("../heal_indicator").color = Color(1,0,0)

func set_maxhp(value):
	max_hp = value
	update_hp()

func update_hp():
	hpbar.value = hp
	hpbar.max_value = max_hp
	hplabel.text = (str(round(hp)) + "/" + str(round(max_hp)))

func spawn_damage_number(num, damage=true):
	var dnum = dnum_res.instance()
	dnum.get("custom_fonts/font").size = 35
	dnum.get("custom_fonts/font").outline_size = 4
	if damage:
		dnum.modulate = Color(1,0,0,1)
	else:
		dnum.modulate = Color(0,1,0,1)
	call_deferred("add_child", dnum)
	dnum.wake(num, $DNumPoint.global_transform.origin, get_viewport())

func set_xp(value):
	xp = value
	update_exp()
	if xp >= xp_threshold:
		level_up()
	
func enter_first_person():
	ray = get_node("Camera/RayCast")
	right_weapon.cast = ray
	left_weapon.cast = ray
	$DNumPoint.translation = Vector3(0,1.5,-3)
	$body_pivot.hide()
	AudioServer.set_bus_volume_db(4, -5)
	$Controller/InnerGimbal/Camera.current = false
	$WeaponMountR.translation = Vector3(5.632, -1, -4.282)
	$WeaponMountL.translation = Vector3(-5.732, -1, -4.282)
	$Camera.look_at(cast_point, Vector3(0,1,0))
	$Camera.current = true

func exit_first_person():
	ray = get_node("Controller").get_node("InnerGimbal/Camera/RayCast")
	right_weapon.cast = ray
	left_weapon.cast = ray
	$body_pivot.show()
	$DNumPoint.translation = Vector3(0,3.5,0)
	AudioServer.set_bus_volume_db(4, 0)
	$Camera.current = false
	$WeaponMountR.translation = Vector3(1.832, 0, -1.282)
	$WeaponMountL.translation = Vector3(-1.826, 0, -1.282)
	$Controller/InnerGimbal/Camera.look_at(cast_point, Vector3(0,1,0))
	$Controller/InnerGimbal/Camera.current = true
	
func update_exp():
	xpbar.value = xp
	xpbar.max_value = xp_threshold
	xplabel.text = (str(round(xp)) + "/" + str(round(xp_threshold)))
	lev_label.text = ("Level: " + str(level))
	cash_label.text = ("Cash: %s" % cash)

func level_up():
	self.max_hp *= 1.04
	hp = max_hp
	$levelup.play()
	update_hp()
	damage_scale *= 1.04
	level += 1
	xp_threshold *= 1.3
	self.xp = 0.0

func enemy_killed(xp_amnt):
	cash += int(round((xp_amnt * 0.8) * cash_scale))
	self.xp += xp_amnt
	perf_stats["killed"] += 1
	update_exp()

func _ready():
	weapon_changed(true, $WeaponMountR.get_child(0))
	weapon_changed(false, $WeaponMountL.get_child(0))
	update_exp()

func hit(amnt, loc, nrm, entity):
	self.healing = false
	hp -= amnt
	update_hp()
	$heal_timer.start()
	if hp <= 0:
		emit_signal("death")
		die()
	else:
		spawn_damage_number(amnt)

func die():
	call_deferred("remove_parts")
	game.died(perf_stats)
	on_death()
		
func on_death():
	pass

func replace_weapon(right, weapon):
	if right:
		right_weapon.queue_free()
		r_mount.add_child(weapon)
		weapon_changed(true, weapon)
	else:
		left_weapon.queue_free()
		l_mount.add_child(weapon)
		weapon_changed(false, weapon)

func weapon_changed(right, weapon):
	if right:
		right_weapon = weapon
		right_weapon.equip()
		wep_ui.get_node("RightWeaponPanel/2ndCD").max_value = right_weapon.secondary_cooldown
		right_weapon.cooldown_display = wep_ui.get_node("RightWeaponPanel/2ndCD")
		wep_ui.get_node("RightWeaponPanel/Icon").texture = right_weapon.icon
		wep_ui.get_node("RightWeaponPanel/Label").text = right_weapon.wep_name
		wep_ui.get_node("RightWeaponPanel/DPS").text = ("DPS: " + str(round(right_weapon.primary_damage / right_weapon.rate)))
	else:
		left_weapon = weapon
		left_weapon.equip()
		wep_ui.get_node("LeftWeaponPanel/2ndCD").max_value = left_weapon.secondary_cooldown
		left_weapon.cooldown_display = wep_ui.get_node("LeftWeaponPanel/2ndCD")
		wep_ui.get_node("LeftWeaponPanel/Icon").texture = left_weapon.icon
		wep_ui.get_node("LeftWeaponPanel/Label").text = left_weapon.wep_name
		wep_ui.get_node("LeftWeaponPanel/DPS").text = ("DPS: " + str(round(left_weapon.primary_damage / left_weapon.rate)))

func right_hand_attack1():
	right_weapon.primary_attack()

func right_hand_attack2():
	right_weapon.secondary_attack()

func left_hand_attack1():
	left_weapon.primary_attack()

func left_hand_attack2():
	left_weapon.secondary_attack()


func remove_parts():
	$CollisionShape.queue_free()
	$Controller.queue_free()

func _process(delta):
	var cp = ray.get_node("cast_point").global_transform.origin
	right_weapon.look_at(cp, Vector3(0,1,0))
	left_weapon.look_at(cp, Vector3(0,1,0))
	cast_to = cp
	if ray.is_colliding():
		cast_point = ray.get_collision_point()
	else:
		cast_point = cp
	wep_ui.get_node("RightWeaponPanel/2ndCD").value = ((right_weapon.cooldown.time_left) * -1 + right_weapon.cooldown.wait_time)
	wep_ui.get_node("LeftWeaponPanel/2ndCD").value = ((left_weapon.cooldown.time_left) * -1 + left_weapon.cooldown.wait_time)
	
	if Input.is_action_pressed("add_xp"):
		self.xp = xp + 1.0
	
	if healing:
		if hp < max_hp:
			if can_heal:
				hp += heal_amnt
				spawn_damage_number(heal_amnt,false)
				hp = clamp(hp,0,max_hp)
				update_hp()
				can_heal = false
				$heal_interval.start()
		else:
			self.healing = false
	
#	if cam_cast.is_colliding():
#		cam.global_transform.origin = (cam_cast.get_collision_point() + cam_cast.get_collision_normal() * 0.1)
#	else:
#		cam.translation = cam_cast.cast_to

func _on_heal_timer_timeout():
	self.healing = true

func heal():
	can_heal = true
	
func on_floor() -> bool:
	if $floor_detect.is_colliding():
		return true
	else:
		return false
		
