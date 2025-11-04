extends RigidBody2D
class_name Bullet

var gunParent : Gun

func _on_body_entered(body: Node) -> void:
	if body.has_method("hit"):
		body.hit(gunParent)
	queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
