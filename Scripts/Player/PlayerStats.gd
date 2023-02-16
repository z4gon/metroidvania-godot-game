extends Resource

class_name PlayerStats

# hp
export (int) var MAX_HP = 4
var hp = MAX_HP setget set_hp

# missiles
export (int) var MAX_MISSILES = 300
var missiles = 0 setget set_missiles
var missiles_unlocked = false

# signals
signal player_died
signal player_hp_changed(current_hp)
signal player_missiles_changed(current_count)
signal player_missiles_unlocked

func set_hp(value: int):
	hp = clamp(value, 0, MAX_HP)
	emit_signal("player_hp_changed", hp)
	if hp <= 0:
		emit_signal("player_died")
		
	commit_to_save_system()

func set_missiles(value: int):
	missiles = clamp(value, 0, MAX_MISSILES)
	emit_signal("player_missiles_changed", missiles)
	
	if not missiles_unlocked:
		missiles_unlocked = true
		emit_signal("player_missiles_unlocked")
		
	commit_to_save_system()

func commit_to_save_system():
	SaveSystem.game_state.player_stats = get_save_data()
	
func load_from_save_system():
	var stats = SaveSystem.game_state.player_stats
	
	missiles_unlocked = false
	if stats.keys().size() > 0:
		set_hp(stats.hp)
		set_missiles(stats.missiles)

func reset_for_new_game():
	print_debug("reset_for_new_game")
	hp = MAX_HP
	missiles = 0
	commit_to_save_system()

func get_save_data():
	return {
		"hp": hp,
		"missiles": missiles,
		"missiles_unlocked": missiles_unlocked,
	}
