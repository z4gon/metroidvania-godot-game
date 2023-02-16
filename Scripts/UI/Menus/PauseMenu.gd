extends ColorRect

var is_paused = false setget set_is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	
	if is_paused:
		SFX.play("Pause", -12, rand_range(0.95, 1.05))
	else:
		SFX.play("Unpause", -12, rand_range(0.95, 1.05))
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = !is_paused

func _on_ResumeButton_pressed():
	self.is_paused = false

func _on_QuitButton_pressed():
	play_click_sfx()
	get_tree().quit()

func play_click_sfx():
	SFX.play("Click", -10)
