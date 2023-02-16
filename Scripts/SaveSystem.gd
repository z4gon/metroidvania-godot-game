extends Node

const SAVE_FILE_PATH : String = "user://save_game.save"
const NODES_GROUP_TO_PERSIST : String = "Persists"

func save_game():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	
	var persisting_nodes = get_tree().get_nodes_in_group(NODES_GROUP_TO_PERSIST)
	for node in persisting_nodes:
		var node_data = node.save()
		file.store_line(to_json(node_data))
	
	file.close()
	
func load_game():
	var file = File.new()
	if not file.file_exists(SAVE_FILE_PATH):
		return
		
	var persisting_nodes = get_tree().get_nodes_in_group(NODES_GROUP_TO_PERSIST)
	for node in persisting_nodes:
		node.queue_free()
		
	file.open(SAVE_FILE_PATH, File.READ)
	
	# recreate nodes
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
