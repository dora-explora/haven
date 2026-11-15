extends Node2D

func on_body_entered(body: Node2D) -> void:
	if body == $Player:
		$Player.dir = -$Player.dir
