extends Powerup

func _on_Powerup_body_entered(body):
	Global.player_stats.missiles += 1
	._on_Powerup_body_entered(body)
