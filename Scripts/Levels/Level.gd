extends Node2D

class_name Level

func _ready():
	Global.current_level = self

func get_save_data():
	return SaveSystem.get_basic_save_data(self)
