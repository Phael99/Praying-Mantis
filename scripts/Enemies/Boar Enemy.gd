extends KinematicBody2D

enum{ROAM, LURE, STAGGER}
var state = ROAM

onready var enemy_pos = $".".position.x
onready var animated_sprite = $AnimatedSprite
onready var ledge_check_r = $LedheCheckR
onready var ledge_check_l = $LedgeCheckL

var GRAVITY = 30
var HEALTH = 3

var velocity = Vector2.ZERO
var current_health = HEALTH
var direction = Vector2.RIGHT * -1
var player_position
var invunerability = false

#func _ready():
#	pass



func _process(delta):
	
	
	var found_wall = is_on_wall()
	var found_ledge = not ledge_check_r.is_colliding() or not ledge_check_l.is_colliding()
	
	locate_player()
	
	
	if is_on_floor():
		match state:
			ROAM:
				velocity = direction * 50
			LURE:
				velocity = direction * 150 
			STAGGER:
				velocity = Vector2.ZERO
		
		if found_wall or found_ledge:
			direction *= -1
			$DetectPlayer.scale *= -1
			animated_sprite.flip_h = direction.x > 0
	else:
		apply_gravity()
	
	
	velocity = move_and_slide(velocity, Vector2.UP)




func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == "Hurt":
			animated_sprite.play("Walk")

func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)


func _on_DetectPlayer_body_entered(body):
	if body is Player:
		state = LURE
		animated_sprite.play("Run")

func _on_DetectPlayer_body_exited(body):
	if body is Player:
		state = ROAM
		animated_sprite.play("Walk")
	

func locate_player():
	player_position = Global.player_position.x - position.x
	player_position = player_position/abs(player_position)

func _on_Timer_timeout():
	state = ROAM
	invunerability = false
	flip_to_player()
	if current_health<=0:
		queue_free()
	
	$Stagger.stop()

func flip_to_player():
	if direction.x > 0 and player_position < 0:
				direction *= -1 
				$DetectPlayer.scale *= -1
				animated_sprite.flip_h = direction.x > 0
	if direction.x < 0 and player_position > 0:
				direction *= -1
				$DetectPlayer.scale *= -1
				animated_sprite.flip_h = direction.x > 0


func _on_HitBox_body_entered(body):
	if body is Player:
		body.hurt()


func _on_HitBox_area_entered(area):
	if area.is_in_group("Sword") and not invunerability:
		animated_sprite.play("Hurt")
		current_health-=1
		state = STAGGER
		invunerability = true
		$Stagger.start()
		position.x += 50 * (player_position * -1)
		velocity = move_and_slide(velocity, Vector2.UP)
	
	if area.is_in_group("Magic") and not invunerability:
		animated_sprite.play("Hurt")
		current_health-=2
		state = STAGGER
		invunerability = true
		$Stagger.start()
		position.x += 50 * (player_position * -1)
		velocity = move_and_slide(velocity, Vector2.UP)

func handle_fall_death():
	if position.y >= 1250:
		queue_free()
		
