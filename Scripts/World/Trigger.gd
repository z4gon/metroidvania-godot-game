extends Area2D

class_name Trigger

const WORLD_LAYER_BIT = 1
var enabled = true setget set_enabled

signal triggered

func _on_Trigger_body_entered(body):
	if enabled:
		set_enabled(false)
		emit_signal("triggered")

func set_enabled(value: bool):
	enabled = value
	set_collision_layer_bit(WORLD_LAYER_BIT, enabled)
