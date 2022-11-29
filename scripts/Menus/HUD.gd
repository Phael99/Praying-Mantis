extends CanvasLayer

var game_paused = false
var health : float = 3
var mana : float = 3
var potions
# Called when the node enters the scene tree for the first time.
func _ready():
	show_health()
	show_mana()
	show_potions()



func _process(delta):
	show_health()
	show_mana()
	show_potions()
	health = PowerUpHandler.player_health
	mana = PowerUpHandler.player_mana
	potions = PowerUpHandler.potions




func show_health():
	$HealthBar3.scale.x = health/3


func show_mana():
	$ManaBar.scale.x = mana/3

func show_potions():
	if potions == 0:
		$Potion1.visible = false
		$Potion2.visible = false
		$Potion3.visible = false
	if potions == 1:
		$Potion1.visible = true
		$Potion2.visible = false
		$Potion3.visible = false
	if potions == 2:
		$Potion1.visible = true
		$Potion2.visible = true
		$Potion3.visible = false
	if potions == 3:
		$Potion1.visible = true
		$Potion2.visible = true
		$Potion3.visible = true


func _on_BossEnabler_show_health():
	$BossHealth.visible = true
