extends Area2D

class_name Powerup

func _on_Powerup_body_entered(_body):
	SFX.play("Powerup", -12, rand_range(0.95, 1.05))
	queue_free()
