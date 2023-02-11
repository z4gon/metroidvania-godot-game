extends KinematicBody2D

# movement
export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25

# forces
export (int) var GRAVITY = 500
export (int) var JUMP_FORCE = 200
export (int) var MAX_SLOPE_ANGLE = 46

var motion = Vector2.ZERO

# animation
onready var animator : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
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
	
func apply_horizontal_force(input_vector: Vector2, delta: float):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		
func apply_friction(input_vector: Vector2):
	if is_on_floor() and input_vector.x == 0:
		motion.x = lerp(motion.x, 0, FRICTION) 
		
func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		interrupt_jump()
		
func interrupt_jump():
	var half_jump_force = -JUMP_FORCE / 2
	if Input.is_action_just_released("ui_up") and motion.y < half_jump_force:
		motion.y = half_jump_force

func apply_gravity(delta: float):
#	if not is_on_floor():
	motion.y += GRAVITY * delta
	motion.y = min(motion.y, JUMP_FORCE)
	
# if colliding with other rigid bodies, it will prevent movement
# returns the "leftover" motion, to be able to slide over other rigid bodies
func move():
	var ground_normal = Vector2.UP
	motion = move_and_slide(motion, ground_normal)
	
func update_animations(input_vector: Vector2):
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
		animator.play("Run")
	else:
		animator.play("Idle")
		
	if not is_on_floor():
		animator.play("Jump")
