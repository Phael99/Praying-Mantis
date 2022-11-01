extends KinematicBody2D
class_name Player

signal show_health

export(PackedScene) var MAGIC = preload("res://Scenes/Player/Magic.tscn")

var velocity = Vector2.ZERO

## salva posição do jogador

export(int) var MAX_SPEED = 175
export(int) var FRICION = 30
export(int) var ACCELERATION = 30
export(int) var GRAVITY = 30
export(int) var JUMP_FORCE = -750
export(int) var JUMP_RELEASE_FORCE = -500
export(int) var ADDITIONAL_FALL_GRAVITY = 150
export(int) var DASH_SPEED = 1500
export(int) var DASH_ACC = 1
export(int) var HEALTH = 3

var double_jump = 1
var invunerability = false
var is_dead = false
var is_being_hurt = false

var current_health = HEALTH

var is_attacking = false
var is_walking = false
var is_dashing = false
var can_dash = true
var can_use_magic = true
var dash_direction: Vector2 = Vector2.ZERO
var direction = 1

## POWER UPS
var has_dash = PowerUpHandler.has_dash
var has_magic = PowerUpHandler.has_magic
##

onready var animatedSprite = $AnimatedSprite
onready var dashTimer = $DashTimer
onready var magicCooldown = $MagicCooldown
onready var attackCollision = $AttackCollision/CollisionShape2D

func _ready():
	animatedSprite.play("Idle")
	emit_signal("show_health", current_health)



func _process(delta):
	emit_signal("show_health", current_health)
	Global.player_position = position
	
	
	if not is_dashing:
		apply_gravity()
	
	if not is_dead:
		handle_dash(direction)
		if not is_dashing and not is_attacking:
			move()
			#Jump
			if is_on_floor():
				can_dash = true
				input_jump()
				double_jump = 1
			else:
				if not is_attacking and not is_being_hurt:
					animatedSprite.play("Fall")
				input_jump_release()
				input_double_jump()
				apply_additional_gravity()
			#attack
			if Input.is_action_just_pressed("Action"):
				init_attack()
		
		if Input.is_action_just_pressed("Magic"):
			use_magic()
		
		handle_fall_death()
		
		velocity = move_and_slide(velocity, Vector2.UP)

func move():
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	
	if not is_attacking and not is_dashing:
		if input.x == 0:
			animatedSprite.play("Idle")
			apply_friction()
			is_walking = false
		else:
			apply_acceleration(input.x)
			animatedSprite.play("Run")
			is_walking = true
	else:
		apply_friction()
	if input.x < 0:
		direction = -1
		animatedSprite.flip_h = true
		$AttackCollision.position.x = -85
		animatedSprite.position.x = -5
	elif input.x > 0:
		direction = 1
		animatedSprite.flip_h = false
		$AttackCollision.position.x = 10
		$CollisionShape2D.position.x = 0
		animatedSprite.position.x = 5.5


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED *amount, ACCELERATION)

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_additional_gravity():
	if velocity.y > 0:
		velocity.y += ADDITIONAL_FALL_GRAVITY	

func input_jump():
	if Input.is_action_just_pressed("Jump"):
		velocity.y = JUMP_FORCE
		animatedSprite.play("Jump")

func input_jump_release():
	if Input.is_action_just_released("Jump") and velocity.y < -500:
		velocity.y = JUMP_RELEASE_FORCE

func input_double_jump():
	if Input.is_action_just_pressed("Jump") and double_jump > 0:
		velocity.y = JUMP_FORCE
		double_jump -= 1

func init_attack():
	is_attacking = true
	SoundPlayer.play_sound(SoundPlayer.ATTACK)
	animatedSprite.play("Attack")
	attackCollision.disabled = false

func handle_dash(amount):
	if Input.is_action_just_pressed("Dash") and can_dash and has_dash:
		is_dashing = true
		can_dash = false
		dashTimer.start(0.3)
		dash_direction = dash()
	
	if is_dashing:
		animatedSprite.play("Dash")
		dash_direction = move_and_slide(dash_direction)
		if is_being_hurt:
			is_dashing = false

func dash() -> Vector2:
	var input_vector: Vector2 = Vector2.ZERO
	SoundPlayer.play_sound(SoundPlayer.DASH)
	input_vector.x == Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = 0
	if input_vector == Vector2.ZERO:
		input_vector.x = direction
	return input_vector * DASH_SPEED

func hurt():
	if not invunerability:
		SoundPlayer.play_sound(SoundPlayer.HURT)
		animatedSprite.play("Hurt")
		current_health-=1
		is_being_hurt = true
		invunerability = true
		$Invunarability.start()
		velocity.x -= 500 * direction
		velocity.y -= 500
	if current_health <=0 :
		is_dead = true
		animatedSprite.play("Death")

func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "Attack":
		$AttackCollision/CollisionShape2D.disabled = true
		is_attacking = false
	if animatedSprite.animation == "Dash":
		is_dashing = false
		velocity.x = move_toward(velocity.x, 0, 1200)
	if animatedSprite.animation == "Hurt":
		animatedSprite.play("Idle")
	if animatedSprite.animation == "Death":
		queue_free()
		Global.emit_signal("player_died")


func _on_Invunarability_timeout():
	invunerability = false
	is_being_hurt = false

func _on_DashTimer_timeout():
	is_dashing = false
	dashTimer.stop()

func handle_fall_death():
	if position.y >= 1000:
		queue_free()
		Global.emit_signal("player_died")


func use_magic():
	if has_magic and can_use_magic and not is_dashing and not is_attacking:
		SoundPlayer.play_sound(SoundPlayer.MAGIC)
		var magic = MAGIC.instance()
		get_tree().current_scene.add_child(magic)
		if direction > 0:
			magic.scale.x = 1
		if direction < 0:
			magic.scale.x = -1
			magic.direction *= -1
		magic.global_position = self.global_position + Vector2(20 * direction, -50)
		magicCooldown.start(1)
		can_use_magic = false


func _on_MagicCooldown_timeout():
	can_use_magic = true
	magicCooldown.stop()
