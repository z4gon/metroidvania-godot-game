extends Node

class_name PlayerStatsManager

onready var PlayerStats = ResourcesLoader.PlayerStats
onready var events_bus = EventsBus
onready var animator = $InvincibilityAnimator

var is_invincible = false setget set_is_invincible

func _ready():
	PlayerStats.connect("player_died", self, "on_player_died")

func set_is_invincible(value):
	is_invincible = value

func _on_HurtBox_hit(damage: int):
	PlayerStats.hp -= damage
	animator.play("Blink")
	events_bus.trigger("player_hit", { offset = 1, duration = .5 })

func on_player_died():
	get_parent().queue_free()
