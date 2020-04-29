extends Spatial


func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

