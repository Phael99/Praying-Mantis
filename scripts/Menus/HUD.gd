extends CanvasLayer

var game_paused = false
var health = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	show_health()
	




func show_health():
	if health == 3:
		$HealthBar3.visible = true
		$HealthBar2.visible = true
		$HealthBar.visible = true
	if health == 2:
		$HealthBar3.visible = false
		$HealthBar2.visible = true
		$HealthBar.visible = true
	if health == 1:
		$HealthBar3.visible = false
		$HealthBar2.visible = false
		$HealthBar.visible = true
	if health <= 0:
		$HealthBar3.visible = false
		$HealthBar2.visible = false
		$HealthBar.visible = false


func _on_Player_show_health(life):
	health = life
