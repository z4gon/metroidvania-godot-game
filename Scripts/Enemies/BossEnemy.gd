extends Enemy

const EnemyBullet = preload("res://Scenes/Enemies/EnemyBullet.tscn")

onready var ray_cast_right_wall : RayCast2D = $RayCastRightWall
onready var ray_cast_left_wall : RayCast2D = $RayCastLeftWall

export (int) var ACCELERATION = 70
export (float) var CHASE_RANGE = 100.0

func _physics_process(delta):
	chase_player(delta)

func chase_player(delta):
	var player = Global.player
	if player != null and is_instance_valid(player):
		var distance_to_player : Vector2 = player.global_position - global_position
		var on_range = distance_to_player.length() <= CHASE_RANGE
			
		if on_range:
			var direction_to_move = sign(distance_to_player.x)
			linear_velocity.x += ACCELERATION * delta * direction_to_move
			linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)
			
			linear_velocity = move_and_slide(linear_velocity)

			var max_angle = (linear_velocity.x / MAX_SPEED) * 10 # magic number to tilt the enemy
			rotation_degrees = lerp(rotation_degrees, max_angle, 0.3)
			
			stop_on_walls()
			
func stop_on_walls():
	var on_right_wall = ray_cast_right_wall.is_colliding() and linear_velocity.x > 0
	var on_left_wall = ray_cast_left_wall.is_colliding() and linear_velocity.x < 0
	
	if on_left_wall or on_right_wall:
		linear_velocity.x *= 0.5
