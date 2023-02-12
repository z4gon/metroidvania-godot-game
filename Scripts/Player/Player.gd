extends KinematicBody2D

# movement
export (int) var ACCELERATION = 512
export (int) var MAX_HORIZONTAL_SPEED = 64
export (float) var FRICTION = 0.25
var linear_velocity = Vector2.ZERO

# accelerations
export (int) var GRAVITY_ACCELERATION = 500
export (int) var JUMP_SPEED = 200

# ground and snapping
export (int) var MAX_SLOPE_ANGLE = 46
var ground_normal = Vector2.UP
var stop_on_slope = true
var max_slides = 4
var snap_vector = Vector2.DOWN

# animation
onready var animator : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

# jumping
var just_jumped : bool = false
var just_landed : bool = false
var just_left_floor : bool = false
onready var edge_jump_timer : Timer = $EdgeJumpTimer

signal jumped
signal landed

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_acceleration(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	update_animations(input_vector)
	move()

func get_input_vector() -> Vector2:
	var vec = Vector2.ZERO
	vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return vec
	
func apply_horizontal_acceleration(input_vector: Vector2, delta: float):
	if input_vector.x != 0:
		linear_velocity.x += input_vector.x * ACCELERATION * delta
		linear_velocity.x = clamp(linear_velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
		
func apply_friction(input_vector: Vector2):
	if is_on_floor() and input_vector.x == 0:
		linear_velocity.x = lerp(linear_velocity.x, 0, FRICTION) 
		
func jump_check():
	just_jumped = false
	if is_on_floor() or edge_jump_timer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			linear_velocity.y = -JUMP_SPEED
			just_jumped = true
			emit_signal("jumped")
	else:
		interrupt_jump()
		
func interrupt_jump():
	var half_jump_speed = -JUMP_SPEED / 2
	if Input.is_action_just_released("ui_up") and linear_velocity.y < half_jump_speed:
		linear_velocity.y = half_jump_speed

func apply_gravity(delta: float):
	if not is_on_floor():
		linear_velocity.y += GRAVITY_ACCELERATION * delta
		linear_velocity.y = min(linear_velocity.y, JUMP_SPEED)
	
# if colliding with other rigid bodies, it will prevent movement
# returns the "leftover" linear_velocity, to be able to slide over other rigid bodies
func move():
	var was_on_floor = is_on_floor()
	
	just_landed = false
	just_left_floor = false
	
	linear_velocity = move_and_slide_with_snap(
		linear_velocity, 
		snap_vector,
		ground_normal, 
		stop_on_slope,
		max_slides,
		deg2rad(MAX_SLOPE_ANGLE)
	)
	
	just_left_floor = was_on_floor and not is_on_floor()
	just_landed = not was_on_floor and is_on_floor()
	
	if just_left_floor and not just_jumped:
		edge_jump_timer.start()
		
	if(just_landed):
		emit_signal("landed")
	
func update_animations(input_vector: Vector2):
	var movement_sign = sign(input_vector.x)
	var gun_pointing_sign = sign(get_local_mouse_position().x)
	
	sprite.scale.x = gun_pointing_sign
	
	if input_vector.x != 0:
		animator.play("Run")
		animator.playback_speed = movement_sign * gun_pointing_sign
	else:
		animator.play("Idle")
		animator.playback_speed = 1
		
	if not is_on_floor():
		animator.play("Jump")
