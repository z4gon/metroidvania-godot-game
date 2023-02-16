extends Node

var player : Player = null
var camera : Camera2D = null
var player_stats : PlayerStats = null setget set_player_stats
var current_level : Level = null

var broadcast_done = false

signal player_stats_set(player_stats)

func set_player_stats(value):
	player_stats = value
	if not broadcast_done:
		emit_signal("player_stats_set", player_stats)
		broadcast_done = true
