extends KinematicBody2D
class_name Mantis

var velocity = Vector2.ZERO
export(int) var MAX_SPEED = 175
export(int) var FRICION = 30
export(int) var ACCELERATION = 30
export(int) var GRAVITY = 30
export(int) var JUMP_FORCE = -750
export(int) var JUMP_RELEASE_FORCE = -500
export(int) var ADDITIONAL_FALL_GRAVITY = 150

var double_jump = 1
var player_position

func _ready():
	pass # Replace with function body.



func _process(delta):
	apply_gravity()
	follow_player()
	
	
	"""
	if is_on_floor():
			input_jump()
			double_jump = 1
	else:
		input_jump_release()
		input_double_jump()
		apply_additional_gravity()
	"""
	
	velocity = move_and_slide(velocity, Vector2.UP)
"""
func input_jump():
	if Input.is_action_just_pressed("Jump"):
		velocity.y = JUMP_FORCE

func input_jump_release():
	if Input.is_action_just_released("Jump") and velocity.y < -500:
		velocity.y = JUMP_RELEASE_FORCE

func input_double_jump():
	if Input.is_action_just_pressed("Jump") and double_jump > 0:
		velocity.y = JUMP_FORCE
		double_jump -= 1
"""""
func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_additional_gravity():
	if velocity.y > 0:
		velocity.y += ADDITIONAL_FALL_GRAVITY	

func follow_player():
	if global_position.distance_to(Global.player_position) > 50:
		velocity = global_position.direction_to(Global.player_position -Vector2(50,-50)) * MAX_SPEED 
		$AnimatedSprite.flip_h = global_position.direction_to(Global.player_position).x > 0
		velocity = move_and_slide(velocity)


