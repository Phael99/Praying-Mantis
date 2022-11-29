extends Area2D

signal active
signal show_health
var is_active = true

func _on_BossEnabler_body_entered(body):
	if body is Player:
		emit_signal("active", is_active)
		emit_signal("show_health")
		$CollisionShape2D.disabled = true
		is_active = false
