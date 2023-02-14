extends Node2D

var Utils = preload("res://Scripts/Utils.gd")
var DustVFX = preload("res://Scenes/VFX/DustVFX.tscn")

onready var timer : Timer = $Timer

func start_spawning():
	timer.start()
	
func stop_spawning():
	timer.stop()

func spawn():
	Utils.instantiate(self, DustVFX, global_position)

func _on_Timer_timeout():
	spawn()
