extends Node

# by event id
var events_listeners : Dictionary = {}

func register_listener(event: String, listener: Object, callback_name: String) -> int:
	if not events_listeners.has(event):
		events_listeners[event] = []
	
	events_listeners[event].append({
		object = listener,
		callback_name = callback_name
	})
	
	return events_listeners[event].size() - 1

func unregister_listener(event: String, listener_idx: int):
	if not events_listeners.has(event) or events_listeners[event].size() == 0:
		push_warning("unregister_listener: there are no registered listeners for event %s" % event)
		return
		
	events_listeners[event].remove(listener_idx)

func trigger(event: String, args: Dictionary):
	if not events_listeners.has(event) or events_listeners[event].size() == 0:
		push_warning("trigger: there are no registered listeners for event %s" % event)
		return
	
	for listener in events_listeners[event]:
		# https://docs.huihoo.com/godotengine/godot-docs/godot/classes/class_object.html#class-object-callv
		listener.object.callv(listener.callback_name, args.values())
