extends KinematicBody2D

# movement
export (int) var ACCELERATION = 512
export (int) var MAX_VELOCITY = 64
export (float) var FRICTION = 0.25

# forces
export (int) var GRAVITY_ACCELERATION = 500
export (int) var JUMP_VELOCITY = 200
export (int) var MAX_SLOPE_ANGLE = 46

var linear_velocity = Vector2.ZERO

var ground_normal = Vector2.UP
var stop_on_slopes = true

# animation
onready var animator : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

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
		linear_velocity.x = clamp(linear_velocity.x, -MAX_VELOCITY, MAX_VELOCITY)
		
func apply_friction(input_vector: Vector2):
	if is_on_floor() and input_vector.x == 0:
		linear_velocity.x = lerp(linear_velocity.x, 0, FRICTION) 
		
func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			linear_velocity.y = -JUMP_VELOCITY
	else:
		interrupt_jump()
		
func interrupt_jump():
	var half_jump_velocity = -JUMP_VELOCITY / 2
	if Input.is_action_just_released("ui_up") and linear_velocity.y < half_jump_velocity:
		linear_velocity.y = half_jump_velocity

func apply_gravity(delta: float):
#	if not is_on_floor():
	linear_velocity.y += GRAVITY_ACCELERATION * delta
	linear_velocity.y = min(linear_velocity.y, JUMP_VELOCITY)
	
# if colliding with other rigid bodies, it will prevent movement
# returns the "leftover" linear_velocity, to be able to slide over other rigid bodies
func move():
	linear_velocity = move_and_slide(linear_velocity, ground_normal, stop_on_slopes)
	
func update_animations(input_vector: Vector2):
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
		animator.play("Run")
	else:
		animator.play("Idle")
		
	if not is_on_floor():
		animator.play("Jump")
