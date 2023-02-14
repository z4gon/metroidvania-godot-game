extends Enemy

var EnemyBullet = preload("res://Scenes/Enemies/EnemyBullet.tscn")

export (float) var BULLET_SPEED = 50.0
export (float) var SPREAD_ANGLE = 30.0

onready var fire_origin = $FireOrigin
onready var fire_direction = $FireDirection

func fire_bullet():
	var bullet = Utils.instantiate(self, EnemyBullet, fire_origin.global_position)
	
	# orientation and velocity
	var direction = (fire_direction.global_position - global_position).normalized()
	bullet.linear_velocity = direction * BULLET_SPEED
	bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(rand_range(-SPREAD_ANGLE/2, SPREAD_ANGLE/2)))
