extends Node

export(Array, AudioStream) var streams = []

var music_list_index = 0

onready var player = $AudioStreamPlayer

func _ready():
	play_music()

func play_music():
	if streams.size() == 0:
		return
		
	player.stream = streams[music_list_index]
	player.play()
	
	music_list_index = (music_list_index + 1) % streams.size()

func _on_AudioStreamPlayer_finished():
	play_music()
