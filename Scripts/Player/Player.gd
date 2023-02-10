extends KinematicBody2D

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (int) var FRICTION = 0.25

var motion = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		# accelerate until a cap
		motion += input_vector * ACCELERATION * delta
		motion = motion.clamped(MAX_SPEED)
	else:
		# make it go back to zero
		motion = motion.linear_interpolate(Vector2.ZERO, FRICTION) 
		
	# applies the motion
	# if colliding with other rigid bodies, it will prevent movement
	# returns the "leftover" motion, to be able to slide over other rigid bodies
	motion = move_and_slide(motion)

func get_input_vector():
	var vec = Vector2.ZERO
	vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return vec
