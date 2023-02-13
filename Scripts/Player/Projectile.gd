extends Node2D

class_name Projectile

var velocity : Vector2 = Vector2.ZERO

func _process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _on_HitBox_body_entered(body):
	queue_free()

func _on_HitBox_area_entered(hurtBox: Area2D):
	queue_free()
