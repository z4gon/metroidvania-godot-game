extends Projectile

class_name PlayerMissile

var BigExplosionVFX = preload("res://Scenes/VFX/BigExplosionVFX.tscn")

const BRICKS_LAYER_BIT = 5

func _ready():
	SFX.play("Bullet", -10, rand_range(0.8, 1.1))

# override
func _on_HitBox_body_entered(body):
	var body_is_brick = body.get_collision_layer_bit(BRICKS_LAYER_BIT)
	if body_is_brick:
		Utils.instantiate(self, BigExplosionVFX, body.global_position)
		body.queue_free()

	._on_HitBox_body_entered(body)
