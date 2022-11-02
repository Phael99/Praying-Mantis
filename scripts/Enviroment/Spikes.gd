extends Area2D



func _on_HitBox_body_entered(body):
	if not body is Player: return
	body.hurt()
	body.velocity = Vector2.ZERO
	body.position = Global.checkpoint

