extends Node2D

export (float) var BULLET_SPEED = 250.0
export (float) var MISSILE_SPEED = 120.0

onready var parent = get_parent()

onready var fire_origin = $Sprite/FireOrigin
onready var fire_bullet_timer = $FireBulletTimer

var Utils = preload("res://Scripts/Utils.gd")
var PlayerBullet = preload("res://Scenes/Player/PlayerBullet.tscn")
var PlayerMissile = preload("res://Scenes/Player/PlayerMissile.tscn")

signal missile_fired(missile_velocity)

func _process(_delta):
	point_to_mouse()
	fire_bullet()
	fire_missile()

func point_to_mouse():
	rotation = parent.get_local_mouse_position().angle()

func fire_bullet():
	if Input.is_action_pressed("fire") and fire_bullet_timer.time_left == 0:
		var bullet : PlayerBullet = Utils.instantiate(self, PlayerBullet, fire_origin.global_position)
		bullet.linear_velocity = Vector2.RIGHT.rotated(rotation) * BULLET_SPEED
		bullet.linear_velocity.x *= parent.scale.x # the sprite is flipped
		bullet.rotation = bullet.linear_velocity.angle()
		fire_bullet_timer.start()

func fire_missile():
	if Input.is_action_just_pressed("fire_alt") and Global.player_stats.missiles > 0:
		var missile : PlayerMissile = Utils.instantiate(self, PlayerMissile, fire_origin.global_position)
		missile.linear_velocity = Vector2.RIGHT.rotated(rotation) * MISSILE_SPEED
		missile.linear_velocity.x *= parent.scale.x # the sprite is flipped
		missile.rotation = missile.linear_velocity.angle()
		
		Global.player_stats.missiles -= 1
		
		emit_signal("missile_fired", missile.linear_velocity)
