extends Node2D

onready var player = get_parent()

func _process(_delta):
	point_to_mouse()

func point_to_mouse():
	rotation = player.get_local_mouse_position().angle()
