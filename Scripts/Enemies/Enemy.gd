extends KinematicBody2D

class_name Enemy

export (int) var MAX_SPEED = 15
var linear_velocity = Vector2.ZERO

onready var stats = $EnemyStatsManager

func _on_HurtBox_hit(damage: float):
	stats.hp -= damage 

func _on_EnemyStats_enemy_died():
	queue_free()
