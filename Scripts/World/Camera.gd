extends Camera2D

export (float) var MAX_SHAKE_OFFSET = 8.0
var shake_offset = 0

onready var events_bus = EventsBus
onready var timer = $ShakeTimer

func _ready():
	events_bus.register_listener("player_hit", self, "screen_shake") 
	
func _process(_delta):
	if shake_offset == 0:
		return
		
	offset_h = rand_range(-shake_offset, shake_offset)
	offset_v = rand_range(-shake_offset, shake_offset)

func screen_shake(offset: float = 1, duration: float = 1):
	shake_offset = offset
	timer.wait_time = duration
	timer.start()
	
func _on_ShakeTimer_timeout():
	shake_offset = 0
	offset_h = 0
	offset_v = 0
