extends Area2D

@export var item: InvItem


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect(item)
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
