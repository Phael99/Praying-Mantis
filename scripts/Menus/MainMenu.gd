extends Control


func _ready():
	$Bg/VBoxContainer/Start.grab_focus()
	SoundPlayer.play_music(SoundPlayer.MAIN_MENU)
	
	focus_changed()

func _exit_tree():
	SoundPlayer.stop_music(SoundPlayer.MAIN_MENU)

func _on_Start_pressed():
	var _change_scene = get_tree().change_scene("res://Scenes/Stages/Demo.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Continue_mouse_entered():
	$Bg/VBoxContainer/Continue.grab_focus()
	SoundPlayer.play_sound(SoundPlayer.MENU)


func _on_Start_mouse_entered():
	$Bg/VBoxContainer/Start.grab_focus()
	SoundPlayer.play_sound(SoundPlayer.MENU)


func _on_Options_mouse_entered():
	$Bg/VBoxContainer/Options.grab_focus()
	SoundPlayer.play_sound(SoundPlayer.MENU)


func _on_Exit_mouse_entered():
	$Bg/VBoxContainer/Exit.grab_focus()
	SoundPlayer.play_sound(SoundPlayer.MENU)

func focus_changed():
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		SoundPlayer.play_sound(SoundPlayer.MENU)
