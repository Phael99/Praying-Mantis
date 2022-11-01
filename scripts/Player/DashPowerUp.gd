extends Area2D

func _on_DashPowerUp_body_entered(body):
	if body is Player:
		body.has_dash = true
		PowerUpHandler.has_dash = true
		queue_free()


