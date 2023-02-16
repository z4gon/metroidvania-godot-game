extends Projectile

class_name PlayerBullet

func _ready():
	SFX.play("Bullet", -10, rand_range(0.8, 1.1))
	set_process(false) # don't move the bullet until the fire animation finishes
