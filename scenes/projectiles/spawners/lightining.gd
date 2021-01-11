extends base_proj_spawner

func on_spawn():
	friendly = true
	$boom.play()
	
func _process(delta):
	if rand_range(0,1) > 0.5:
		$lightning_sprite.visible = !$lightning_sprite.visible
	$lightning_sprite.opacity -= 0.015
	if $OmniLight.light_energy > 0.0:
		$OmniLight.light_energy -= 0.2
	$lightning_sprite.pixel_size = global_transform.origin.distance_to(entity.translation) / rand_range(400,450)
