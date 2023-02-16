extends Node

class_name PlayerStatsManager

onready var stats = preload("res://Resources/Player/PlayerStats.tres")
onready var events_bus = EventsBus
onready var animator = $InvincibilityAnimator

var is_invincible = false setget set_is_invincible

signal player_died

func _ready():
	Global.player_stats = stats
	stats.connect("player_died", self, "on_player_died")
	load_stats_from_save()

func set_is_invincible(value):
	is_invincible = value

func _on_HurtBox_hit(damage: int):
	if not is_invincible:
		self.is_invincible = true
		stats.hp -= damage
		animator.play("Blink")
		events_bus.trigger("player_hit", { offset = 1, duration = .5 })
		SFX.play("Hurt", -10, rand_range(0.8, 1.1))

func on_player_died():
	emit_signal("player_died")

func load_stats_from_save():
	if not SaveSystem.scheduled_to_load:
		return
		
	Global.player_stats.load_from_save_system()
