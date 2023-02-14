extends Node

onready var camera : Camera2D = $Camera

func _ready():
	Global.camera = camera
	VisualServer.set_default_clear_color(Color.black)
