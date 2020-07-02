extends base_proj_spawner

func on_spawn():
	$Particles.emitting = true
	$blast.opacity = -0.15
	$blast/blasttop.opacity = -0.15
	$blast/blastbottom.opacity = -0.15
	$boom.play()

func _process(delta):
	$blast.scale += Vector3(0.04,0,0.04)
	$blast/blasttop.scale += Vector3(0.001,0,0.001)
	$blast/blastbottom.scale += Vector3(0.001,0,0.001)
	if $blast.opacity < 0:
		$blast.opacity += 0.0005
		$blast/blasttop.opacity += 0.0005
		$blast/blastbottom.opacity += 0.0005
	else:
		if $blast.visible:
			$blast.hide()
