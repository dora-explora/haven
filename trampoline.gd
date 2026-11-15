extends Area2D

func on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.jump()
		$AnimatedSprite.play("bounce")
