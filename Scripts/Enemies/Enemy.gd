extends KinematicBody2D

class_name Enemy

var Utils = preload("res://Scripts/Utils.gd")
var BigExplosionVFX = preload("res://Scenes/VFX/BigExplosionVFX.tscn")

export (int) var MAX_SPEED = 15
var linear_velocity = Vector2.ZERO

onready var stats = $EnemyStatsManager

signal died

func _on_HurtBox_hit(damage: float):
	stats.hp -= damage 

func _on_EnemyStats_enemy_died():
	die()
	
func die():
	SFX.play("EnemyDie", -20, rand_range(0.8, 1.1))
	emit_signal("died")
	spawn_death_vfx()
	queue_free()

func spawn_death_vfx():
	Utils.instantiate(self, BigExplosionVFX, global_position)
