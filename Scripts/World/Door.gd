extends Node2D

class_name Door

export (Resource) var DOOR_CONNECTION # 00_door_01.tres
export (String, FILE, "*.tscn") var NEXT_LEVEL_FILE_PATH = "" # res://Scenes/Levels/Level_01.tscn
export (bool) var active = true

onready var events_bus = EventsBus

func _on_Door_body_entered(_body):
	active = false
	events_bus.trigger("player_entered_door", { door = self })
