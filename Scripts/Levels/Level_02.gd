extends Level

const WORLD_LAYER_BIT = 1

onready var door_block : TileMap = $DoorBlock

func _on_DoorBlockTrigger_triggered():
	enable_door_block(true)

func _on_BossEnemy_died():
	enable_door_block(false)

func enable_door_block(enable: bool):
	door_block.visible = enable
	door_block.set_collision_layer_bit(WORLD_LAYER_BIT, enable)
