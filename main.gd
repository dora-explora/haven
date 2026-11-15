extends Node2D

var jumped = false
var levels: Array[PackedScene]
var levelinstance: Node2D
var level = 0

func _ready() -> void:
	for wall: Area2D in get_tree().get_nodes_in_group("bouncable_walls"):
		wall.connect("body_entered", on_area_2d_body_entered)
	$player/LeftParticles.emitting = true
	$player/RightParticles.emitting = true
	levels = [
		preload("res://level0.tscn"), 
		preload("res://level1.tscn")
	]
	levelinstance = levels[level].instantiate()
	add_child(levelinstance)

func _process(_delta: float) -> void:
	if $player.jumped:
		$StartPlatform.visible = false
		$StartPlatform/CollisionShape2D.disabled = true

func on_area_2d_body_entered(body: Node2D) -> void:
	if body == $player:
		$player.dir = -$player.dir
	if (level % 2 == 0 and body.name == "wallR") or (level % 2 == 1 and body.name == "wallL"):
		print("swapping!")
		remove_child(levelinstance)
		level += 1
		levelinstance = levels[level].instantiate()
		add_child(levelinstance)
