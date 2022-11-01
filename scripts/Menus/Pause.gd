extends Control

func _ready():
	self.hide()
	# Connect the signals to the buttons, the [button] pass which button has triggered the function.
	for button in $VBoxContainer.get_children():
		button.connect("focus_entered", self, "_on_button_focus_entered", [button])
		button.connect("mouse_entered", self, "_on_button_mouse_entered", [button])
		button.connect("focus_exited", self, "_on_button_focus_exited", [button])
func _input(event):
	if Input.is_action_just_pressed("Pause"):
		change_pause_status()	
		
		if self.visible:
			$VBoxContainer/Resume.grab_focus()
			
func _on_button_mouse_entered(button):
	button.grab_focus()

func change_pause_status():
	# When we pause, we pause everything, so it's important to not pause this node. To do it, go to Inspector > Pause > Mode:Process 
	get_tree().paused = !get_tree().paused
	self.visible = get_tree().paused	


func _on_Resume_pressed():
	change_pause_status()


func _on_Quit_pressed():
	get_tree().paused = false
	var _change_scene = get_tree().change_scene("res://Scenes/HUD/MainMenu.tscn")
