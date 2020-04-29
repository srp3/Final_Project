extends KinematicBody

var curHp : int = 10
var maxHp : int = 10
var ammo : int = 15
var score: int = 0

var moveSpeed : float = 20.0
var jumpForce : float = 5.0
var gravity : float = 10.0

var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0

var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

onready var camera : Camera = get_node("Camera")

onready var muzzle : Spatial = get_node("Camera/flamethrower/Muzzle")

onready var bulletScene = load("res://Bullet.tscn")
onready var ui : Node = get_node("/root/Mainscene/CanvasLayer/UI")
onready var gun: Node = get_node("/root/Mainscene/Gun")

func _ready ():

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)
	ui.update_score_text(score)

func _physics_process(delta):

	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input.y += 5
	if Input.is_action_pressed("move_backward"):
		input.y -= 5
	if Input.is_action_pressed("move_left"):
		input.x += 5
	if Input.is_action_pressed("move_right"):
		input.x -= 5
		
	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed	
	
	vel.y -= gravity * delta
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce

func _process(delta):
	
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	
	if score == 200 :
		get_tree().change_scene("res://Win.tscn")
		
	mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()
		
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func shoot ():
	gun.playing = true
	var bullet = bulletScene.instance()
	get_node("/root/Mainscene").add_child(bullet)

	bullet.global_transform = muzzle.global_transform
	
	ammo -= 1
	
	ui.update_ammo_text(ammo)

func take_damage (damage):
	
	curHp -= damage
	
	ui.update_health_bar(curHp, maxHp)
	
	if curHp <= 0:
		die()
func die ():
	
	get_tree().change_scene("res://Control.tscn")
	
func add_score (amount):
	
	score += amount
	ui.update_score_text(score)
	
	
func add_health (amount):
	
	curHp += amount
	
	if curHp > maxHp:
		curHp = maxHp
		
	ui.update_health_bar(curHp, maxHp)
	
func add_ammo (amount):
	
	ammo += amount
	ui.update_ammo_text(ammo)

func win ():
	if score == 200 :
		get_tree().change_scene("res://Win.tscn")
