extends Node

const MAIN_MENU = preload("res://Audio/Music/MainMenu.wav")
const PHASE1 = preload("res://Audio/Music/Phase1.ogg")
const BOAR_BOSS = preload("res://Audio/Music/BoarBoss.wav")

const HURT = preload("res://Audio/Sfx/Hurt.wav")
const JUMP = preload("res://Audio/Sfx/Jump.wav")
const MAGIC = preload("res://Audio/Sfx/Magic.wav")
const STEP = preload("res://Audio/Sfx/Step.wav")
const DEATH = preload("res://Audio/Sfx/Death.wav")
const DASH = preload("res://Audio/Sfx/Dash.wav")
const ATTACK = preload("res://Audio/Sfx/Attack.wav")
const MENU = preload("res://Audio/Sfx/menu_23.wav")

onready var audioPlayers = $AudioPlayers
onready var musicPlayers = $MusicPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

func play_music(sound):
	for musicStreamPlayer in musicPlayers.get_children():
		if not musicStreamPlayer.playing:
			musicStreamPlayer.stream = sound
			musicStreamPlayer.play()
			break

func stop_music(sound):
	for musicStreamPlayer in musicPlayers.get_children():
		if musicStreamPlayer.stream == sound:
			musicStreamPlayer.stop()
			break

func stop_any_music():
	for musicStreamPlayer in musicPlayers.get_children():
		if musicStreamPlayer.playing:
			musicStreamPlayer.stop()
