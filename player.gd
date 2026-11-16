extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var run_speed = 150
@export var jump_speed = -300
enum {IDLE, RUN, JUMP}
var state = IDLE
var dir = 0
var jumped = false
var level = 0

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

func get_input():
	var rightbutton = Input.is_action_just_pressed("right")
	var leftbutton = Input.is_action_just_pressed("left")
	var jumpbutton = Input.is_action_pressed("jump")
	var onfloor = is_on_floor()
	if jumpbutton: jumped = true
	
	if rightbutton and onfloor and jumped and state == IDLE: dir = 1
	if leftbutton and onfloor and jumped and state == IDLE: dir = -1
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
	if state in [IDLE, RUN] and !onfloor:
		change_state(JUMP)
	
	# only jump while on ground
	if jumpbutton and onfloor:
		jump()
	# if falling, change to IDLE when hit ground
	if state == JUMP and onfloor:
		change_state(IDLE)


func _process(delta: float) -> void:
	velocity.y += gravity * delta
	$Camera.position_smoothing_enabled = true
	get_input()
	move_and_slide()
	
	$Camera.drag_horizontal_offset = dir
	$RightParticles.emitting = dir == 1.
	$RightParticles.visible = dir == 1.
	$LeftParticles.emitting = dir == -1.
	$LeftParticles.visible = dir == -1.
