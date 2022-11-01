extends Area2D




func _on_CheckPoint_body_entered(body):
	if not body is Player: return
	Global.emit_signal("checkpoint_hit", position)
