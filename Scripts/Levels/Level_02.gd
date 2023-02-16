extends Level

const WORLD_LAYER_BIT = 1

onready var door_block : TileMap = $DoorBlock
onready var door_block_trigger : Trigger = $DoorBlockTrigger

func _ready():
	load_from_save()

func _on_DoorBlockTrigger_triggered():
	enable_door_block(true)

func _on_BossEnemy_died():
	enable_door_block(false)

func enable_door_block(enable: bool):
	door_block.visible = enable
	door_block.set_collision_layer_bit(WORLD_LAYER_BIT, enable)

func load_from_save():
	if SaveSystem.game_state.boss_killed:
		door_block.queue_free()
		door_block_trigger.queue_free()
