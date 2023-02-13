extends ColorRect

var is_paused = false setget set_is_paused

func set_is_paused(value):
	print_debug("set_is_paused(%s)" % value)
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = !is_paused

func _on_ResumeButton_pressed():
	print_debug("_on_ResumeButton_pressed")
	self.is_paused = false

func _on_QuitButton_pressed():
	get_tree().quit()
