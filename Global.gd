extends Node

signal player_died
signal checkpoint_hit(checkpoint_position)

var player_position
var checkpoint

func _ready():
	checkpoint = player_position
