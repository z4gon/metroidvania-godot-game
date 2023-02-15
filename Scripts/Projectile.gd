extends Node2D

class_name Projectile

var linear_velocity : Vector2 = Vector2.ZERO

var Utils = preload("res://Scripts/Utils.gd")
var ExplosionVFX = preload("res://Scenes/VFX/ExplosionVFX.tscn")

func _process(delta):
	position += linear_velocity * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _on_HitBox_body_entered(_body: PhysicsBody2D):
	explode()

func _on_HitBox_area_entered(_hurtBox: Area2D):
	explode()

func explode():
	Utils.instantiate(self, ExplosionVFX, global_position)
	queue_free()
