extends Area2D



var is_in_body
export(PackedScene) var text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_in_body and Input.is_action_just_pressed("ui_up"):
		get_tree().current_scene.add_child(text.instance())
		


func _on_Sign_body_entered(body):
	$Label.visible = true
	is_in_body = true


func _on_Sign_body_exited(body):
	$Label.visible = false
	is_in_body = false
