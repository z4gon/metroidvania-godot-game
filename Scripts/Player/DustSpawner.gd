extends Node2D

var Utils = preload("res://Scripts/Utils.gd")
var DustVFX = preload("res://Scenes/VFX/DustVFX.tscn")

func spawn_dust_effect():
	Utils.instantiate(self, DustVFX, global_position)

func _on_Player_jumped():
	spawn_dust_effect()

func _on_Player_landed():
	spawn_dust_effect()
