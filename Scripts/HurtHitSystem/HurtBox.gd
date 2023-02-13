extends Area2D

class_name HurtBox

signal hit(damage)

func take_damage(damage: float):
	emit_signal("hit", damage)
