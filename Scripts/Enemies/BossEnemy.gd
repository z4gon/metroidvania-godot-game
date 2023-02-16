extends Enemy

const EnemyBullet = preload("res://Scenes/Enemies/EnemyBullet.tscn")

onready var ray_cast_right_wall : RayCast2D = $RayCastRightWall
onready var ray_cast_left_wall : RayCast2D = $RayCastLeftWall

# movement
export (int) var ACCELERATION = 70
export (float) var CHASE_RANGE = 100.0

# fire bullets
export (float) var BULLET_SPEED = 50.0
export (float) var SPREAD_ANGLE = 30.0

func _ready():
	load_from_save()

func _physics_process(delta):
	chase_player(delta)

func chase_player(delta):
	if player_is_in_range():
		var direction_to_move = sign(distance_to_player().x)
		linear_velocity.x += ACCELERATION * delta * direction_to_move
		linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)
		
		linear_velocity = move_and_slide(linear_velocity)

		var max_angle = (linear_velocity.x / MAX_SPEED) * 10 # magic number to tilt the enemy
		rotation_degrees = lerp(rotation_degrees, max_angle, 0.3)

		stop_on_walls()

func distance_to_player() -> Vector2:
	return Global.player.global_position - global_position
			
func player_is_in_range():
	var player = Global.player
	if player != null and is_instance_valid(player):
		return distance_to_player().length() <= CHASE_RANGE
	
	return false
	
func stop_on_walls():
	var on_right_wall = ray_cast_right_wall.is_colliding() and linear_velocity.x > 0
	var on_left_wall = ray_cast_left_wall.is_colliding() and linear_velocity.x < 0
	
	if on_left_wall or on_right_wall:
		linear_velocity.x *= -0.5

func _on_FireTimer_timeout():
	fire_bullet()

func fire_bullet():
	if player_is_in_range():
		var bullet = Utils.instantiate(self, EnemyBullet, global_position)
		bullet.linear_velocity = Vector2.DOWN * BULLET_SPEED
		bullet.linear_velocity = bullet.linear_velocity.rotated(deg2rad(rand_range(-SPREAD_ANGLE/2, SPREAD_ANGLE/2)))
		
func die():
	SaveSystem.game_state.boss_killed = true
	.die()

func load_from_save():
	if SaveSystem.game_state.boss_killed:
		queue_free()
