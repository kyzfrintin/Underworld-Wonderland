extends Spatial


onready var bigrocks = $radialrocks/big
onready var small_top = $radialrocks/small/toplayer
onready var small_bot = $radialrocks/small/bottomlayer



func _ready():
	for i in bigrocks.get_children():
		i.translate(Vector3(0,rand_range(-500,500),0))
		$Tween.interpolate_property(i, 'translation:y', i.translation.y, rand_range(-20000,-10000), rand_range(40,60), Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	for i in small_top.get_children():
		i.translate(Vector3(0,rand_range(-100,500),0))
		var sca = rand_range(1,5)
		i.rotation = Vector3(rand_range(0,360),rand_range(0,360),rand_range(0,360))
		i.scale = Vector3(i.scale.x * (sca * rand_range(0.8,1.2)), i.scale.y * (sca * rand_range(0.8,1.2)), i.scale.z * (sca * rand_range(0.8,1.2)))
		$Tween.interpolate_property(i, 'translation:y', i.translation.y, rand_range(-4000,4000), rand_range(20,30), Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	for i in small_bot.get_children():
		i.translate(Vector3(0,rand_range(-500,100),0))
		var sca = rand_range(1,5)
		i.rotation = Vector3(rand_range(0,360),rand_range(0,360),rand_range(0,360))
		i.scale = Vector3(i.scale.x * (sca * rand_range(0.8,1.2)), i.scale.y * (sca * rand_range(0.8,1.2)), i.scale.z * (sca * rand_range(0.8,1.2)))
		$Tween.interpolate_property(i, 'translation:y', i.translation.y, rand_range(-4000,4000), rand_range(10,20), Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	$Tween.connect("tween_completed", self, "height_tween_end")

func height_tween_end(rock, key):
	var type = rock.get_parent().name
	match type:
		"big":
			$Tween.interpolate_property(rock, 'translation:y', rock.translation.y, rand_range(-20000,-10000), rand_range(40,60), Tween.TRANS_EXPO, Tween.EASE_OUT)
		"toplayer":
			$Tween.interpolate_property(rock, 'translation:y', rock.translation.y, rand_range(-4000,4000), rand_range(20,30), Tween.TRANS_EXPO, Tween.EASE_OUT)
		"botlayer":
			$Tween.interpolate_property(rock, 'translation:y', rock.translation.y, rand_range(-4000,4000), rand_range(10,20), Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
