extends Enemy

export (int) var ACCELERATION = 100
export (float) var CHASE_RANGE = 100.0

# animation
onready var sprite = $Sprite
onready var animator = $AnimationPlayer

func _physics_process(delta):
	var player = Global.player
	if player != null and is_instance_valid(player):
		chase_player(player, delta)

func chase_player(player, delta):
	var distance_to_player : Vector2 = player.global_position - global_position
	if distance_to_player.length() <= CHASE_RANGE:
		# accelerate
		var direction = distance_to_player.normalized()
		linear_velocity += direction * ACCELERATION * delta
		linear_velocity = linear_velocity.limit_length(MAX_SPEED)

		# animations
		sprite.flip_h = global_position < player.global_position
		
		# move
		linear_velocity = move_and_slide(linear_velocity)
		
		animator.playback_speed = 2.5
		
	animator.playback_speed = 1
