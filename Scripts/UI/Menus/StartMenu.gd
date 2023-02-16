extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	show_world()

func _on_LoadButton_pressed():
	SaveSystem.scheduled_to_load = true
	show_world()

func _on_QuitButton_pressed():
	get_tree().quit()

func show_world():
	var _error = get_tree().change_scene("res://Scenes/World/World.tscn")
