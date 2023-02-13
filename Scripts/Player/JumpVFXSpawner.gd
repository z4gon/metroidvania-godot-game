extends Node2D

var Utils = preload("res://Scripts/Utils.gd")
var JumpVFX = preload("res://Scenes/VFX/JumpVFX.tscn")

func spawn_effect():
	Utils.instantiate(self, JumpVFX, global_position)

func _on_Player_jumped():
	spawn_effect()
