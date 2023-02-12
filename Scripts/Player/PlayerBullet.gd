extends Projectile

class_name PlayerBullet

func _ready():
	set_process(false) # don't move the bullet until the fire animation finishes
