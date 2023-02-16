extends StaticBody2D

class_name SaveStation

onready var animator = $AnimationPlayer

func _on_Area2D_body_entered(_body):
	SaveSystem.save_game()
	animator.play("Save")
