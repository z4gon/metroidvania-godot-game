extends Node2D

func _ready():
	SFX.play("Explosion", -14, rand_range(0.8, 1.1))
