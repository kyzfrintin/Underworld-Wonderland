extends Spatial

export(NodePath) var PlayerPath  = "" #You must specify this in the inspector!
export(float) var MovementSpeed = 10.0
export(float) var Acceleration = 3
export(float) var MaxJump = 19
export(float) var MouseSensitivity = 2
export(float) var RotationLimit = 45
export(float) var MaxZoom = 0.35
export(float) var MinZoom = 1.5
export(float) var ZoomSpeed = 2

var first_person = false
var r_attack_held = false
var l_attack_held = false

var multi = 1.0
var sprint = 1.7
var Player
var InnerGimbal
var Direction = Vector3()
var Rotation = Vector2()
var gravity = -10
var Movement = Vector3()
var ZoomFactor = 0.7
var FovFactor = 100
var ActualZoom = 1
var Speed = Vector3()
var CurrentVerticalSpeed = Vector3()
var JumpAcceleration = 3
var IsAirborne = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$InnerGimbal/Camera/RayCast.add_exception(get_parent())
	Player = get_node(PlayerPath)
	InnerGimbal =  $InnerGimbal
	pass

func _input(event):
	
	if event is InputEventMouseMotion :
		Rotation = event.relative

func _process(delta):
	
	if Input.is_action_just_pressed("gp_pause"):
		Player.game.get_node("UI").pause()
	
	if Input.is_action_pressed("cam_up"):
		Rotation.y -= Input.get_action_strength("cam_up") * 15
	if Input.is_action_pressed("cam_down"):
		Rotation.y += Input.get_action_strength("cam_down") * 15
	if Input.is_action_pressed("cam_right"):
		Rotation.x += Input.get_action_strength("cam_right") * 15
	if Input.is_action_pressed("cam_left"):
		Rotation.x -= Input.get_action_strength("cam_left") * 15
	
	#camera
	if Input.is_action_just_pressed("cam_zoomin"):
		ZoomFactor -= 0.3
		if ZoomFactor < 0.16:
			Player.enter_first_person()
			first_person = true
	if Input.is_action_just_pressed("cam_zoomout"):
		ZoomFactor += 0.3
		if first_person:
			first_person = false
			Player.exit_first_person()
	ZoomFactor = clamp(ZoomFactor, MaxZoom, MinZoom)
	
	#attack
	if Input.is_action_pressed("gp_right_hand_prim_attack"):
		get_parent().right_hand_attack1()
		r_attack_held = true
	if Input.is_action_just_released("gp_right_hand_prim_attack"):
		r_attack_held = false
	if Input.is_action_just_pressed("gp_right_hand_second_attack"):
		if !Player.in_bubble:
			get_parent().right_hand_attack2()
	
	if Input.is_action_pressed("gp_left_hand_prim_attack"):
		get_parent().left_hand_attack1()
		l_attack_held = true
	if Input.is_action_just_released("gp_left_hand_prim_attack"):
		l_attack_held = false
	if Input.is_action_just_pressed("gp_left_hand_second_attack"):
		if !Player.in_bubble:
			get_parent().left_hand_attack2()
	
	#sprinting
	if Input.is_action_just_pressed("gp_sprint_toggle"):
		if multi == 1.0:
			multi = sprint
			if !first_person:
				ZoomFactor = 1.2
			else:
				FovFactor = 120
		else:
			multi = 1.0
			if !first_person:
				ZoomFactor = 0.7
			else:
				FovFactor = 100
	
	#movement press
	if Input.is_action_pressed("gp_forward"):
		Direction.z -= Input.get_action_strength("gp_forward")
	if Input.is_action_pressed("gp_back"):
		Direction.z += Input.get_action_strength("gp_back")
	if Input.is_action_pressed("gp_left"):
		Direction.x -= Input.get_action_strength("gp_left")
	if Input.is_action_pressed("gp_right"):
		Direction.x += Input.get_action_strength("gp_right")
	if Input.is_action_just_pressed("gp_jump"):
		if !IsAirborne:
			CurrentVerticalSpeed = Vector3(0,MaxJump * Player.jump_scale,0)
			IsAirborne = true
			Player.get_node("jump").play()
	
	#detect backwards sprinting
	if Direction.z >= 0 and multi == sprint:
		multi = 1.0
		if !first_person:
				ZoomFactor = 0.7
		else:
			FovFactor = 90
	
	#movement release
	if Input.is_action_just_released("gp_forward"):
		Direction.z += 1
	if Input.is_action_just_released("gp_back"):
		Direction.z -= 1
	if Input.is_action_just_released("gp_left"):
		Direction.x += 1
	if Input.is_action_just_released("gp_right"):
		Direction.x -= 1
	Direction.z = clamp(Direction.z, -1,1)
	Direction.x = clamp(Direction.x, -1,1)

func _physics_process(delta):
	#Rotation
	Player.rotate_y(deg2rad(-Rotation.x)*delta*MouseSensitivity)
	var x_rot = deg2rad(-Rotation.y)*delta*MouseSensitivity
	x_rot = clamp(x_rot, -RotationLimit, RotationLimit)
	InnerGimbal.rotate_x(x_rot)
	Player.get_node("Camera").rotate_x(x_rot)
	Rotation = Vector2()
	
	#Movement
	var MaxSpeed = (MovementSpeed * (Player.speed_scale * multi)) *Direction.normalized()
	Speed = Speed.linear_interpolate(MaxSpeed, delta * Acceleration)
	Movement = Player.transform.basis * (Speed)
	CurrentVerticalSpeed.y += gravity * delta * JumpAcceleration
	Movement += CurrentVerticalSpeed
	Player.move_and_slide(Movement,Vector3(0,1,0))
	if Player.is_on_floor() :
		CurrentVerticalSpeed.y = 0
		IsAirborne = false
	
	#Zoom
	ActualZoom = lerp(ActualZoom, ZoomFactor, delta * ZoomSpeed)
	InnerGimbal.set_scale(Vector3(ActualZoom,ActualZoom,ActualZoom))
	Player.get_node("Camera").fov = lerp(Player.get_node("Camera").fov, FovFactor, 0.1)
