extends Area2D



func _on_HitBox_body_entered(body):
	if body is Player:
		body.hurt()

