extends Node2D

onready var linear_velocity = Vector2(rand_range(-20, 20), rand_range(-10, -30))

func _process(delta):
	position += linear_velocity * delta
