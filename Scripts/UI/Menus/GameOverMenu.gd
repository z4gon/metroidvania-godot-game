extends Control

class_name GameOverMenu

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	SaveSystem.reset_for_new_game()
	play_click_sfx()
	show_world()

func _on_LoadButton_pressed():
	play_click_sfx()
	Global.broadcast_done = false
	SaveSystem.scheduled_to_load = true
	SaveSystem.load_game(false)
	show_world()

func _on_QuitButton_pressed():
	play_click_sfx()
	get_tree().quit()

func show_world():
	var _error = get_tree().change_scene("res://Scenes/World/World.tscn")

func play_click_sfx():
	SFX.play("Click", -10)
