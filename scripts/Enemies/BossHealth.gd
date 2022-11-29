extends Control

var health : float
var cur_health : float


# Called when the node enters the scene tree for the first time.
func _ready():
	health = Global.boss_health
	cur_health = Global.boss_current_health

func _process(delta):
	cur_health = Global.boss_current_health
	show_health()

func show_health():
	$ColorRect2.rect_scale.x = cur_health / health
