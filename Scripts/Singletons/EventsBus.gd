extends Node

# by event id
var events_listeners : Dictionary = {}

func register_listener(event: String, listener_object: Object, callback_name: String) -> int:
	if not events_listeners.has(event):
		events_listeners[event] = []
	
	var listener = {
		object = listener_object,
		callback_name = callback_name,
		idx = events_listeners[event].size() - 1
	}
	
	events_listeners[event].append(listener)
	
	return listener.idx

func unregister_listener(event: String, listener_idx: int):
	if not events_listeners.has(event) or events_listeners[event].size() == 0:
		push_warning("unregister_listener: there are no registered listeners for event %s" % event)
		return
		
	events_listeners[event].remove(listener_idx)

func trigger(event: String, args: Dictionary):
	if not events_listeners.has(event) or events_listeners[event].size() == 0:
		push_warning("trigger: there are no registered listeners for event %s" % event)
		return
	
	var idxs_to_purge = []
	for listener in events_listeners[event]:
		if not is_instance_valid(listener.object):
			idxs_to_purge.append(listener.idx)
		else:
			# https://docs.huihoo.com/godotengine/godot-docs/godot/classes/class_object.html#class-object-callv
			listener.object.callv(listener.callback_name, args.values())

	# purge objects that got deleted
	for idx in idxs_to_purge:
		unregister_listener(event, idx)
