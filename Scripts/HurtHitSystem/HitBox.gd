extends Area2D

class_name HitBox

export (int) var damage = 1

func _on_HitBox_area_entered(hurtBox: Area2D):
	hurtBox.take_damage(damage)
