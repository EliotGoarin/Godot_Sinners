extends Area2D

@export var speed: float = 400.0
var direction = Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.name == "Player":
		return # Ignore collisions with the player
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
	
