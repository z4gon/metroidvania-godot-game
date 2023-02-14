extends Node2D

var Utils = preload("res://Scripts/Utils.gd")
var WallDustVFX = preload("res://Scenes/VFX/WallDustVFX.tscn")

func spawn(scale_x: float = 1, offset: Vector2 = Vector2.ZERO):
	var dust = Utils.instantiate(self, WallDustVFX, global_position + offset)
	dust.scale.x = scale_x
