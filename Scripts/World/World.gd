extends Node

onready var camera : Camera2D = $Camera
onready var current_level = $Level_00

var Utils = preload("res://Scripts/Utils.gd")
onready var events_bus = EventsBus

func _ready():
	Global.camera = camera
	VisualServer.set_default_clear_color(Color.black)
	events_bus.register_listener("player_entered_door", self, "on_player_entered_door") 
	load_world_from_save()

func on_player_entered_door(door: Door):
	call_deferred("change_level", door)
	
func change_level(door: Door):
	current_level.visible = false
	
	var NextLevel = load(door.NEXT_LEVEL_FILE_PATH)
	var next_level : Level = Utils.instantiate(self, NextLevel, current_level.global_position)
	
	position_player_on_next_level(door, next_level)
	
	current_level.queue_free()
	current_level = next_level

func position_player_on_next_level(exit_door: Door, next_level: Level):
	var doors = next_level.get_tree().get_nodes_in_group("Doors")
	
	var enter_door: Door = null
	for door in doors:
		if door.DOOR_CONNECTION == exit_door.DOOR_CONNECTION:
			enter_door = door
			
	Global.player.global_position = enter_door.global_position
	
	camera.temporarily_disable_smoothing()
	camera.global_position = Global.player.global_position
	
func load_world_from_save():
	if not SaveSystem.scheduled_to_load:
		return
		
	SaveSystem.load_game()
	SaveSystem.scheduled_to_load = false
	
	# connect the camera
	var camera_follow = Global.player.get_node("CameraFollow")
	camera_follow.remote_path = Global.camera.get_path()
