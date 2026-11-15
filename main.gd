extends Node2D

var jumped = false

func _ready() -> void:
	for wall: Area2D in get_tree().get_nodes_in_group("bouncable_walls"):
		wall.connect("body_entered", on_area_2d_body_entered)
	$player/LeftParticles.emitting = true
	$player/RightParticles.emitting = true

func _process(_delta: float) -> void:
	if $player.position.y < -470 :
		jumped = true
		$StartPlatform.visible = false
		$StartPlatform/CollisionShape2D.disabled = true

func on_area_2d_body_entered(body: Node2D) -> void:
	if body == $player:
		$player.dir = -$player.dir
