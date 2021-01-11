extends Spatial

class_name weapon

#stats
export (float) var secondary_cooldown = 5
export (float) var primary_damage = 4
export (float) var secondary_damage = 60
export var wep_name = ""
export (bool) var continuous = false
export (float) var rate = 0.2
export (Texture) var icon

var cast
var cooldown_display
var can_fire = true
var primary_held = false
var second_fire = true
var right_hand : bool

onready var parent = get_node("../../")
var cooldown
var interval

func _ready():
	parent.connect("death", self, "player_death")
	cooldown = Timer.new()
	interval = Timer.new()
	cooldown.one_shot = true
	interval.one_shot = true
	cooldown.wait_time = secondary_cooldown
	interval.wait_time = rate
	add_child(cooldown)
	add_child(interval)
	cooldown.connect("timeout", self, "reenable_secondary")
	interval.connect("timeout", self, "reenable_primary")

func equip():
	cast = parent.ray
	if get_parent().name == "WeaponMountR":
		right_hand = true
	else:
		right_hand = false
	on_equip()

func player_death():
	pass

func primary_attack():
	if can_fire:
		if !continuous:
			interval.start()
			attack()
		else:
			engage_continuous_attack()
		can_fire = false
		on_first_attack()

func secondary_attack():
	if second_fire:
		can_fire = false
		second_fire = false
		interval.stop()
		on_second_attack()
		if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "primary_attack":
			$AnimationPlayer.stop()
		$AnimationPlayer.play("secondary_attack")
		cooldown.start()

func reenable_primary():
	can_fire = true
	if !check_held():
		$AnimationPlayer.play("def")
	
func reenable_secondary():
	second_fire = true
	if !check_held():
		$AnimationPlayer.play("def")
	cooldown_display.get_node("recharged").play()

func check_held():
	var held = false
	if right_hand:
		if parent.controller.r_attack_held:
			held = true
	else:
		if parent.controller.l_attack_held:
			held = true
	return held

func engage_continuous_attack():
	$AnimationPlayer.play("primary_attack")
	primary_held = true

func disengage_continuous_attack():
	primary_held = false
	interval.start()

func attack():
	pass
	
func on_first_attack():
	pass

func on_second_attack():
	pass

func on_equip():
	pass
