extends Node

signal player_died
signal checkpoint_hit(checkpoint_position)

var player_position
var checkpoint
var boss_health = 24
var boss_current_health = 24

func _ready():
	checkpoint = player_position
