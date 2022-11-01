extends KinematicBody2D
	 
export(int) var SPEED = 200
onready var timer = $Timer 
var direction = Vector2.RIGHT


func _ready():
	timer.start(1)

func _process(delta):
	global_position += SPEED * direction * delta
	check_obstacle()


func destroy():
	queue_free()

 
func check_obstacle():
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		destroy()


func _on_Timer_timeout():
	queue_free()
