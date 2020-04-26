extends Spatial

var dir

func _process(delta):
	translate(dir*2)

func destroy():
	call_deferred("queue_free")
