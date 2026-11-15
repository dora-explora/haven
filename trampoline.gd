extends Area2D

func on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.jump()
		$AnimatedSprite.play("bounce")
