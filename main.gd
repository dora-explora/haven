extends Node2D

var jumped = false
var levels: Array[PackedScene]
var levelinstance: Node2D
@export var level = 0

func _ready() -> void:
	$player/LeftParticles.emitting = true
	$player/RightParticles.emitting = true
	$player.level = level
	levels = [
		preload("res://level0.tscn"), 
		preload("res://level1.tscn"), 
		preload("res://level2.tscn")
	]
	levelinstance = levels[level].instantiate()
	add_child(levelinstance)
	for wall: Area2D in get_tree().get_nodes_in_group("bouncable_walls"):
		wall.connect("body_entered", on_bouncy_entered)
	for wall: Area2D in get_tree().get_nodes_in_group("up_bouncable_walls"):
		wall.connect("body_entered", on_up_bouncy_entered)
	for spike: Area2D in get_tree().get_nodes_in_group("spikes"):
		spike.connect("body_entered", on_spike_entered)

func levelup():
	$RunLabel.visible = false
	remove_child(levelinstance)
	level += 1
	if level >= len(levels): return
	$player.level = level
	levelinstance = levels[level].instantiate()
	add_child(levelinstance)
	for wall: Area2D in get_tree().get_nodes_in_group("bouncable_walls"):
		wall.connect("body_entered", on_bouncy_entered)
	for wall: Area2D in get_tree().get_nodes_in_group("up_bouncable_walls"):
		wall.connect("body_entered", on_up_bouncy_entered)
	for spike: Area2D in get_tree().get_nodes_in_group("spikes"):
		spike.connect("body_entered", on_spike_entered)

func reset():
	$player/Camera.position_smoothing_enabled = false
	level = 0
	if level % 2 == 0: $player.position = Vector2.ZERO
	#else: $player.position = Vector2(2900., 0.)
	$player.velocity = Vector2.ZERO
	$player.change_state(0)
	$player.dir = 0

func _process(_delta: float) -> void:
	if $player.jumped:
		$StartPlatform.visible = false
		$StartPlatform/CollisionShape2D.disabled = true
	if Input.is_action_just_pressed("reset"): reset()
	if position.y > 10: reset()
	
func on_bouncy_entered(body: Node2D) -> void:
	if body == $player:
		$player.dir = -$player.dir

func on_up_bouncy_entered(body: Node2D) -> void:
	if body == $player:
		$player.dir = -$player.dir
		$player.velocity.y = $player.jump_speed

func on_wallR_entered(body: Node2D) -> void:
	if body != $player: return
	$player.dir = -$player.dir
	if level % 2 == 0:
		levelup()

func on_wallL_entered(body: Node2D) -> void:
	if body != $player: return
	$player.dir = -$player.dir
	if level % 2 == 1:
		levelup()

func on_spike_entered(body: Node2D) -> void:
	if body != $player: return
	reset()
