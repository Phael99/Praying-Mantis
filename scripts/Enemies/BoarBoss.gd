extends KinematicBody2D

onready var animatedSprite: = $AnimatedSprite
onready var stunTimer: = $Stun
onready var inactiveTimer: = $InactiveTimer
onready var invuneravilityTimer: = $Invunerability
onready var detectPlayer: = $DetectPlayer

enum{INACTIVE, IDLE, CHARGE, STUN, DEAD, INIT_CHARGING}
var state = INACTIVE

var HEALTH = 30
var CHARGE_SPEED = 800
var velocity = Vector2.ZERO
var current_health = HEALTH
var direction = Vector2.LEFT
var invunerability = false
var double_damage = 1 #recebe dano dobrado enquanto stunado

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.boss_health = HEALTH
	Global.boss_current_health = current_health



func _process(delta):
	Global.boss_current_health = current_health
	match state:
		INACTIVE:
			animatedSprite.play("Idle")
			$DetectPlayer/CollisionShape2D.disabled = true
		IDLE:
			animatedSprite.play("Walk")
			velocity = direction * 50
			if is_on_wall():
				animatedSprite.flip_h = direction.x < 0
				direction *= -1
				$DetectPlayer.scale *= -1
				
		CHARGE:
			charge()
		STUN:
			animatedSprite.play("Idle")
			double_damage = 2
		DEAD:
			animatedSprite.play("Hurt")
		INIT_CHARGING:
			animatedSprite.play("Charge Init")
	
	
	if current_health<=0:
		state = DEAD
	
	velocity = move_and_slide(velocity, Vector2.UP)

func charge():
	animatedSprite.play("Charge")
	var charge_direction = Vector2.ZERO
	charge_direction = direction
	charge_direction = charge_direction * CHARGE_SPEED
	charge_direction = move_and_slide(charge_direction)
	
	
	if is_on_wall():
		velocity = Vector2.ZERO
		state = STUN
		stunTimer.start(3)


func _on_HitBox_area_entered(area):
	if area.is_in_group("Sword") and not invunerability:
		animatedSprite.play("Hurt")
		current_health-=2 * double_damage
		invunerability = true
		invuneravilityTimer.start(1)
		flip_to_player()
		state = INIT_CHARGING
	if area.is_in_group("Magic") and not invunerability:
		animatedSprite.play("Hurt")
		current_health-=1 * double_damage
		invunerability = true
		invuneravilityTimer.start(1)
		flip_to_player()
		state = INIT_CHARGING
	

func _on_DetectPlayer_body_entered(body):
	if body is Player:
		state = INIT_CHARGING


func _on_Stun_timeout():
	state = IDLE
	double_damage = 1
	stunTimer.stop()
	print("stun off")


func _on_BossEnabler_body_entered(body):
	if not body is Player: return
	state = IDLE
	inactiveTimer.start(1)


func _on_InactiveTimer_timeout():
	$DetectPlayer/CollisionShape2D.disabled = false


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "Hurt":
		queue_free()
	if animatedSprite.animation == "Charge Init":
		state = CHARGE

func _on_Invunerability_timeout():
	invunerability = false
	invuneravilityTimer.stop()

func flip_to_player():
	if direction.x > 0 and Global.player_position.x < 0:
		animatedSprite.flip_h = direction.x < 0
		direction *= -1 
		$DetectPlayer.scale *= -1
	if direction.x < 0 and Global.player_position.x > 0:
		animatedSprite.flip_h = direction.x < 0
		direction *= -1
		$DetectPlayer.scale *= -1


func _exit_tree():
	var _change_scene = get_tree().change_scene("res://Scenes/HUD/EndScreen.tscn")
