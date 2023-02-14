extends Control

#onready var empty_rect = $Empty
onready var full_rect = $Full

var hp_cell_width = 5

func _ready():
	Global.connect("player_stats_set", self, "on_player_stats_set")
	
func on_player_stats_set(player_stats):
	player_stats.connect("player_hp_changed", self, "on_player_hp_changed")
	
func on_player_hp_changed(current_hp):
	full_rect.rect_size.x = 1 + hp_cell_width * current_hp
