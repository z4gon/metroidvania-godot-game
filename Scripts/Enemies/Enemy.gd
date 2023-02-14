extends KinematicBody2D

class_name Enemy

var Utils = preload("res://Scripts/Utils.gd")
var EnemyDeathVFX = preload("res://Scenes/VFX/EnemyDeathVFX.tscn")

export (int) var MAX_SPEED = 15
var linear_velocity = Vector2.ZERO

onready var stats = $EnemyStatsManager

func _on_HurtBox_hit(damage: float):
	stats.hp -= damage 

func _on_EnemyStats_enemy_died():
	spawn_death_vfx()
	queue_free()

func spawn_death_vfx():
	Utils.instantiate(self, EnemyDeathVFX, global_position)
