extends Path2D

var HEALTH = 2

export(PackedScene) var FEATHER = preload("res://Scenes/Enemies/Feather.tscn")

var direction = Vector2.RIGHT * -1
var player_position = Vector2.ZERO
var invunerability = false
var current_health = HEALTH
var can_throw = true

onready var animatedSprite = $PathFollow2D/Area2D/AnimatedSprite
onready var staggerTimer = $Stagger
onready var featherCooldown = $FeatherCooldown

func _ready():
	animatedSprite.play("Idle")



func _process(delta):
	locate_player()
	flip_to_player()
	if can_throw:
		throw_feather()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") and not invunerability:
		current_health -= 1
		invunerability = true
		staggerTimer.start(0.3)
		animatedSprite.play("Hurt")
	
	if area.is_in_group("Magic") and not invunerability:
		current_health -= 2
		invunerability = true
		staggerTimer.start(0.3)
		animatedSprite.play("Hurt")

func locate_player():
	player_position = $".".get_parent().get_child(1).position - position
	player_position.x = player_position.x/abs(player_position.x)
	player_position.y = player_position.y/abs(player_position.y)

func flip_to_player():
	if direction.x > 0 and player_position.x < 0:
				direction *= -1 
				animatedSprite.flip_h = direction.x > 0
	if direction.x < 0 and player_position.x > 0:
				direction *= -1
				animatedSprite.flip_h = direction.x > 0


func _on_Stagger_timeout():
	invunerability = false
	animatedSprite.play("Idle")
	staggerTimer.stop()
	if current_health<=0:
			queue_free()


func _on_Area2D_body_entered(body):
	if body is Player:
		body.hurt()

func throw_feather():
	var feather = FEATHER.instance()
	get_tree().current_scene.add_child(feather)
	feather.direction = position.direction_to(Global.player_position)
	feather.global_position = self.global_position
	featherCooldown.start(3)
	can_throw = false 


func _on_FeatherCooldown_timeout():
	can_throw = true
	featherCooldown.stop()
