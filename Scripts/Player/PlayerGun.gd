extends Node2D

export (float) var BULLET_SPEED = 250.0

onready var parent = get_parent()
onready var fire_origin = $Sprite/FireOrigin
onready var fire_bullet_timer = $FireBulletTimer

var Utils = preload("res://Scripts/Utils.gd")
var PlayerBullet = preload("res://Scenes/Player/PlayerBullet.tscn")

func _process(_delta):
	point_to_mouse()
	fire_bullet()

func point_to_mouse():
	rotation = parent.get_local_mouse_position().angle()

func fire_bullet():
	if Input.is_action_pressed("fire") and fire_bullet_timer.time_left == 0:
		var bullet : PlayerBullet = Utils.instantiate(self, PlayerBullet, fire_origin.global_position)
		bullet.velocity = Vector2.RIGHT.rotated(rotation) * BULLET_SPEED
		bullet.velocity.x *= parent.scale.x # the sprite is flipped
		bullet.rotation = bullet.velocity.angle()
		fire_bullet_timer.start()
