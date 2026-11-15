extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var run_speed = 150
@export var jump_speed = -300
enum {IDLE, RUN, JUMP}
var state = IDLE
var dir = 0
var jumped = false

func _ready():
	change_state(IDLE)
	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN: 
			$AnimationPlayer.play("run")
		JUMP:
			$AnimationPlayer.play("jump")

func jump():
	change_state(JUMP)
	velocity.y = jump_speed

func reset():
	$Camera.position_smoothing_enabled = false
	position = Vector2.ZERO
	velocity = Vector2.ZERO
	change_state(IDLE)
	dir = 0

func get_input():
	var rightbutton = Input.is_action_just_pressed("right")
	var leftbutton = Input.is_action_just_pressed("left")
	var jumpbutton = Input.is_action_pressed("jump")
	if jumpbutton: jumped = true
	
	if rightbutton and is_on_floor() and jumped:
		dir = 1
		$Sprite.flip_h = false
	if leftbutton and is_on_floor() and jumped:
		dir = -1
		$Sprite.flip_h = true
	velocity.x = dir * run_speed
	if dir == 1: $Sprite.flip_h = false
	elif dir == -1: $Sprite.flip_h = true
	# IDLE -> RUN when moving
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN -> IDLE when not moving
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# change to jump when in air
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	# only jump while on ground
	if jumpbutton and is_on_floor():
		jump()
	# if falling, change to IDLE when hit ground
	if state == JUMP and is_on_floor():
		change_state(IDLE)


func _process(delta: float) -> void:
	velocity.y += gravity * delta
	$Camera.position_smoothing_enabled = true
	get_input()
	move_and_slide()
	if Input.is_action_just_pressed("reset"): reset()
	if position.y > 10: reset()
	
	$Camera.drag_horizontal_offset = dir
	$RightParticles.emitting = dir == 1.
	$RightParticles.visible = dir == 1.
	$LeftParticles.emitting = dir == -1.
	$LeftParticles.visible = dir == -1.
