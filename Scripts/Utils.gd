static func instantiate(context: Node, resource: Resource, position: Vector2):
	var instance = resource.instance()						# instantiate the scene
	var root_node = context.get_tree().current_scene 			# get the root node of the main scene
	root_node.add_child(instance)							# add to the root node
	instance.global_position = position						# position in the same place as the ship
	return instance
