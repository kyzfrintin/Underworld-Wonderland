extends Spatial

var dir
var dest
var active  =true

func _ready():
	get_node("Root").look_at(dest, Vector3.UP)

func _process(delta):
	if active:
		translate(dir*2)
	else:
		if $OmniLight.light_energy > 0:
			$OmniLight.light_energy -= 0.04

func destroy():
	active = false
	$OmniLight.light_energy = 10
	$Root.hide()
	yield(get_tree().create_timer(5), "timeout")
	call_deferred("queue_free")
