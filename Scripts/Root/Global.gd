extends Node

var player : Player = null
var camera : Camera2D = null
var player_stats : PlayerStats = null setget set_player_stats

signal player_stats_set(player_stats)

func set_player_stats(value):
	player_stats = value
	emit_signal("player_stats_set", player_stats)
