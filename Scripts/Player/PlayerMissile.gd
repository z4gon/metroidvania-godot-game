extends Projectile

class_name PlayerMissile

const BRICKS_LAYER_BIT = 5

# override
func _on_HitBox_body_entered(body):
	var body_is_brick = body.get_collision_layer_bit(BRICKS_LAYER_BIT)
	if body_is_brick:
		body.queue_free()

	._on_HitBox_body_entered(body)
