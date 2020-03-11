extends MeshInstance


func _on_Area_body_entered(body):
	if body.name == "player":
		body.max_hp += 10
		queue_free()
