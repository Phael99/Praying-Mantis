extends Area2D



func _on_HitBox_body_entered(body):
	if body is Player:
		body.hurt()
		body.velocity = Vector2.ZERO
		body.position = Global.checkpoint

