extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var run_speed = 150
@export var jump_speed = -300
enum {IDLE, RUN, JUMP, CROUCH}
var state = IDLE

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
		CROUCH:
			$AnimationPlayer.play("crouch")

func _input(event):
	# only allow jump if on ground
	if event.is_action_released("jump") and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed

func get_input():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var crouch = Input.is_action_pressed("jump")
	
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	# IDLE -> RUN when moving
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN -> IDLE when not moving
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# change to jump when in air
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	if crouch and is_on_floor():
		change_state(CROUCH)
	# if falling, change to IDLE when hit ground
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
