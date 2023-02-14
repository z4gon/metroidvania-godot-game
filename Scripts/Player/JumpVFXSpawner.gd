extends Node2D

var Utils = preload("res://Scripts/Utils.gd")
var JumpVFX = preload("res://Scenes/VFX/JumpVFX.tscn")

func spawn():
	Utils.instantiate(self, JumpVFX, global_position)
