extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	play_click_sfx()
	show_world()

func _on_LoadButton_pressed():
	play_click_sfx()
	SaveSystem.scheduled_to_load = true
	show_world()

func _on_QuitButton_pressed():
	play_click_sfx()
	get_tree().quit()

func show_world():
	var _error = get_tree().change_scene("res://Scenes/World/World.tscn")

func play_click_sfx():
	SFX.play("Click", -10)
