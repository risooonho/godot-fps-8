extends Area

var damage = 30
var speed = 25

onready var lifeTime = $LifeTime

func _ready():
#	connect("body_entered", self, "_on_bullet_body_entered")
	lifeTime.connect("timeout", self, "_on_lifeTime_timeout")
	
func _process(delta):
	translation += global_transform.basis.x * delta * speed

func _on_bullet_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()
		
func _on_lifeTime_timeout():
	destroy()
	
func destroy():
	queue_free()
