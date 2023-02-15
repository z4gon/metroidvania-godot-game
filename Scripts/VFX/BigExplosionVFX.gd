extends Node2D

func _on_DustVFX_tree_exited():
	queue_free()
