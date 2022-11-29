extends CanvasLayer

var game_paused = false
var health = 0
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


func show_mana():
	$ManaBar.rect_scale.x = mana/3

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
