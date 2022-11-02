extends Area2D

signal active
var is_active = true

func _on_BossEnabler_body_entered(body):
	if body is Player:
		emit_signal("active", is_active)
		$CollisionShape2D.disabled = true
		is_active = false
