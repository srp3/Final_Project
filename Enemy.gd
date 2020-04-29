extends KinematicBody

var health : int = 5
var moveSpeed : float = 2.0

var damage : int = 1
var attackRate : float = 1.0
var attackDist : float = 2.0
var gravity : float = 10.0

var scoreToGive : int = 10
var vel : Vector3 = Vector3()

onready var player : Node = get_node("/root/Mainscene/Player")
onready var timer : Timer = get_node("Timer")
onready var squelch = get_node("/root/Mainscene/Impact")
onready var diefx = get_node("/root/Mainscene/Die")

func _ready():
	timer.set_wait_time(attackRate)
	timer.start()

func _physics_process(delta):
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	vel.y -= gravity * delta
	
	if translation.distance_to(player.translation) > attackDist:
		move_and_slide(dir * moveSpeed, Vector3.UP)

func take_damage (damage):
	squelch.playing = true	
	health -= damage
	if health <= 0:
		die()	

func die ():
	diefx.playing = true
	player.add_score(scoreToGive)
	queue_free()

func attack ():
	
	player.take_damage(damage)

func _on_Timer_timeout():
	
	if translation.distance_to(player.translation) <= attackDist:
		attack()

