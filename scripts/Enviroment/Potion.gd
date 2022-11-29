extends Area2D

func _on_Potion_body_entered(body):
	if body is Player:
		body.potions += 1
		queue_free()
