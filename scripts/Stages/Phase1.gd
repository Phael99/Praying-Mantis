extends Node2D


const PlayerScene = preload("res://Scenes/Player/Player.tscn")


onready var player: = $Player
onready var camera: = $Camera2D


func _ready():
	VisualServer.set_default_clear_color("#453d4f")
	SoundPlayer.play_music(SoundPlayer.PHASE1)
	Global.checkpoint = player.position
	Global.connect("checkpoint_hit", self, "_on_checkpoint_hit")
	Global.connect("player_died", self, "_on_player_died")
	player.connect_camera(camera)
	$BossEnabler.connect("active", self, "_on_boss_enabled")


func _exit_tree():
	SoundPlayer.stop_any_music()

func _on_checkpoint_hit(chepoint_position):
	Global.checkpoint = chepoint_position

func _on_player_died():
	var player = PlayerScene.instance()
	player.position = Global.checkpoint
	add_child(player)
	player.connect_camera(camera)

func _on_boss_enabled(active):
	if active:
		SoundPlayer.stop_music(SoundPlayer.PHASE1)
		SoundPlayer.play_music(SoundPlayer.BOAR_BOSS)
