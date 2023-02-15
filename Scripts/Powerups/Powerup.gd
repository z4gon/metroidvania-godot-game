extends Area2D

class_name Powerup

func _on_Powerup_body_entered(_body):
	queue_free()
