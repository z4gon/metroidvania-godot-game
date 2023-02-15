extends HBoxContainer

onready var label = $Label

func _ready():
	var _error = Global.connect("player_stats_set", self, "on_player_stats_set")
	
func on_player_stats_set(player_stats):
	label.text = "%s" % player_stats.missiles
	var _error = player_stats.connect("player_missiles_changed", self, "on_player_missiles_changed")
	_error = player_stats.connect("player_missiles_unlocked", self, "on_player_missiles_unlocked")
	
func on_player_missiles_changed(current_count):
	label.text = "%s" % current_count

func on_player_missiles_unlocked():
	visible = true
