extends KinematicBody2D

class_name Enemy

export (int) var MAX_SPEED = 15
var linear_velocity = Vector2.ZERO

func _on_HurtBox_hit(damage: float):
	queue_free()
