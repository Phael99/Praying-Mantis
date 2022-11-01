extends Area2D

export(int) var SPEED = 200
onready var timer = $Timer 
var direction = Vector2.RIGHT


func _ready():
	timer.start(3)

func _process(delta):
	global_position += SPEED * direction * delta


func destroy():
	queue_free()


func _on_Magic_area_entered(area):
	if area.is_in_group("Enemy"):
		destroy()


func _on_Timer_timeout():
	queue_free()
	timer.stop()
