extends Area

var speed : float = 50.0
var damage : int = 3


func _process(delta):
	translation += global_transform.basis.z * speed * delta

func destroy ():
	queue_free()

func _on_Bullet_body_entered(body):
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()


