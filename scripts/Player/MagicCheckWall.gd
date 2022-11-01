extends KinematicBody2D




func _process(delta):
	if is_on_wall():
		get_parent().destroy()
