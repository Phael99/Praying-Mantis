extends Control

func _ready():
	$Button.grab_focus()
	
	focus_changed()



func focus_changed():
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		SoundPlayer.play_sound(SoundPlayer.MENU)


func _on_Button_pressed():
	var _change_scene = get_tree().change_scene("res://Scenes/HUD/MainMenu.tscn")
