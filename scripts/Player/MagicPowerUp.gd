extends Area2D



func _on_MagicPowerUp_body_entered(body):
	if body is Player:
		body.has_magic = true
		PowerUpHandler.has_magic = true
		queue_free()
