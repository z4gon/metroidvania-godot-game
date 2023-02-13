extends Node

class_name PlayerStats

onready var animator = $InvincibilityAnimator
var is_invincible = false setget set_is_invincible

func set_is_invincible(value):
	is_invincible = value

func _on_HurtBox_hit(_damage: int):
	animator.play("Blink")
