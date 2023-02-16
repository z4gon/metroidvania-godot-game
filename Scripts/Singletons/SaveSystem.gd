extends Node

var scheduled_to_load = false

const SAVE_FILE_PATH : String = "user://save_game.save"
const NODES_GROUP_TO_PERSIST : String = "Persists"

var game_state = {
	"player_stats": {},
	"boss_killed": false
}

func save_game():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	
	# game state
	file.store_line(to_json(game_state))
	
	var persisting_nodes = get_tree().get_nodes_in_group(NODES_GROUP_TO_PERSIST)
	for node in persisting_nodes:
		var node_data = node.get_save_data()
		file.store_line(to_json(node_data))
	
	file.close()
	
func load_game(regenerate_nodes: bool = true):
	var file = File.new()
	if not file.file_exists(SAVE_FILE_PATH):
		return
		
	var persisting_nodes = get_tree().get_nodes_in_group(NODES_GROUP_TO_PERSIST)
	for node in persisting_nodes:
		node.queue_free()
		
	file.open(SAVE_FILE_PATH, File.READ)
	
	# game state
	if not file.eof_reached():
		game_state = parse_json(file.get_line())
		
	# recreate nodes
	if regenerate_nodes:
		while not file.eof_reached():
			var node_data = parse_json(file.get_line())
			if node_data != null:
				# instance
				var new_node = load(node_data["filename"]).instance()
				# add to parent
				get_node(node_data["parent"]).add_child(new_node, true)
				# set attributes
				new_node.position = Vector2(node_data["position_x"], node_data["position_y"])
		
				# set variables dynamically
				var already_used : Array = ["filename", "parent", "position_x", "position_y"]
				for property_name in node_data.keys():
					if already_used.has(property_name):
						continue
					new_node.set(property_name, node_data[property_name])
	
	file.close()

func get_basic_save_data(node: Node2D):
	var save_dictionary = {
		"filename": node.get_filename(),
		"parent": node.get_parent().get_path(),
		"position_x": node.position.x,
		"position_y": node.position.y
	}
	return save_dictionary
	
func reset_for_new_game():
	Global.broadcast_done = false
	Global.player_stats.reset_for_new_game()
	game_state.boss_killed = false
