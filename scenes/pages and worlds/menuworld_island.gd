extends MeshInstance

var fly_speed : float
var dip_speed : float
var angle : float
var vec : Vector3

func _ready():
	global_translate(Vector3(rand_range(-500,500),rand_range(-330,450),rand_range(-150,100)))
	var sca = rand_range(0.2,1.3)
	scale = (Vector3((sca*1000)*rand_range(0.8,1.2),
								(sca*1000)*rand_range(0.8,1.2),
								(sca*1000)*rand_range(0.8,1.2)))
	rotation_degrees.y = rand_range(0,359)
	fly_speed = rand_range(0.005,0.03)
	dip_speed = rand_range(5,10)
	angle = rand_range(-10,10)
	vec = Vector3(-1,0,0).rotated(Vector3(-1,0,0), deg2rad(angle))
	vec *= fly_speed
	
func _process(delta):
	global_translate(vec)
	if global_transform.origin.x < -500:
		global_transform.origin.x = 550
