extends Camera2D

export (float) var MAX_SHAKE_OFFSET = 8.0
var shake_offset = 0

onready var events_bus = EventsBus
onready var shake_timer = $ShakeTimer
onready var smoothing_timer = $SmoothingTimer

func _ready():
	events_bus.register_listener("player_hit", self, "screen_shake") 
	
func _process(_delta):
	if shake_offset == 0:
		return
		
	offset_h = rand_range(-shake_offset, shake_offset)
	offset_v = rand_range(-shake_offset, shake_offset)

func screen_shake(offset: float = 1, duration: float = 1):
	shake_offset = offset
	shake_timer.wait_time = duration
	shake_timer.start()
	
func _on_ShakeTimer_timeout():
	shake_offset = 0
	offset_h = 0
	offset_v = 0
	
func temporarily_disable_smoothing():
	smoothing_enabled = false
	smoothing_timer.start()

func _on_SmoothingTimer_timeout():
	smoothing_enabled = true
