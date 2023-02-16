extends KinematicBody2D

class_name Player

# vfx
onready var dust_vfx = $DustVFXSpawner
onready var jump_vfx = $JumpVFXSpawner
onready var wall_dust_vfx = $WallDustVFXSpawner

# movement
export (int) var ACCELERATION = 512
export (int) var MAX_HORIZONTAL_SPEED = 64
export (float) var FRICTION = 0.25
var linear_velocity = Vector2.ZERO
var input_vector : Vector2  = Vector2.ZERO

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
onready var animator : AnimationPlayer = $SpriteAnimator
onready var sprite : Sprite = $Sprite

# jumping
export (int) var AIR_JUMPS = 1
var just_jumped : bool = false
var just_landed : bool = false
var just_left_floor : bool = false
onready var edge_jump_timer : Timer = $EdgeJumpTimer
onready var air_jumps = AIR_JUMPS

# wall slide
onready var ray_cast_left_wall : RayCast2D = $RayCastLeftWall
onready var ray_cast_right_wall : RayCast2D = $RayCastRightWall
export (int) var WALL_SLIDE_SPEED = 30
var can_wall_slide = true
var wall_collision_sign : int = 0

# state machine
enum PLAYER_STATE { MOVING, WALL_SLIDING }
var state = PLAYER_STATE.MOVING setget set_state

func _ready():
	Global.player = self

func _physics_process(delta):
	input_vector = get_input_vector()
	wall_collision_sign = get_wall_collision_sign()
	
	match state:
		PLAYER_STATE.MOVING:
			apply_horizontal_acceleration(delta)
			apply_friction()
			jump_check()
			apply_gravity(delta)
			wall_slide_check()
			
		PLAYER_STATE.WALL_SLIDING:
			wall_slide_detach_check(delta)
			apply_wall_slide_acceleration()
			wall_slide_jump_check()
		
	update_animations()
	move()

func get_input_vector() -> Vector2:
	var vec = Vector2.ZERO
	vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return vec
	
func apply_horizontal_acceleration(delta: float):
	if input_vector.x != 0:
		linear_velocity.x += input_vector.x * ACCELERATION * delta
		linear_velocity.x = clamp(linear_velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
		
func apply_friction():
	if is_on_floor() and input_vector.x == 0:
		linear_velocity.x = lerp(linear_velocity.x, 0, FRICTION) 
		
func jump_check():
	just_jumped = false
	if is_on_floor() or edge_jump_timer.time_left > 0:
		jump()
	else:
		interrupt_jump()
		air_jump()
		
func jump():
	if Input.is_action_just_pressed("ui_up"):
		play_jump_sfx()
		linear_velocity.y = -JUMP_SPEED
		just_jumped = true
		jump_vfx.spawn()

func interrupt_jump():
	var half_jump_speed = -JUMP_SPEED / 2
	if Input.is_action_just_released("ui_up") and linear_velocity.y < half_jump_speed:
		linear_velocity.y = half_jump_speed
		
func air_jump():
	if Input.is_action_just_pressed("ui_up") and air_jumps > 0:
		play_jump_sfx()
		linear_velocity.y = -JUMP_SPEED
		jump_vfx.spawn()
		air_jumps -= 1
		
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
		air_jumps = AIR_JUMPS
		dust_vfx.spawn()
		
func set_state(value):
	state = value
	match value:
		PLAYER_STATE.MOVING:
			dust_vfx.stop_spawning()
		PLAYER_STATE.WALL_SLIDING:
			dust_vfx.start_spawning()
	
	var dust_position = Vector2(-wall_collision_sign * 2, 0)
	wall_dust_vfx.spawn(-wall_collision_sign, dust_position)
	
func wall_slide_check():
	if not can_wall_slide:
		can_wall_slide = wall_collision_sign == 0
	
	var hugging_right_wall = Input.is_action_pressed("ui_right") and wall_collision_sign == 1
	var hugging_left_wall = Input.is_action_pressed("ui_left") and wall_collision_sign == -1
	
	if can_wall_slide and not is_on_floor() and (hugging_left_wall or hugging_right_wall):
		self.state = PLAYER_STATE.WALL_SLIDING
		can_wall_slide = false
		
func get_wall_collision_sign() -> int:
	return int(ray_cast_right_wall.is_colliding()) - int(ray_cast_left_wall.is_colliding())
	
func wall_slide_detach_check(delta):
	var detached = false
	
	# reached floor
	if wall_collision_sign == 0 or is_on_floor():
		detached = true
		
	# released
	elif not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		detached = true
	
	# detached to the side
	elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") :
		linear_velocity.x = -wall_collision_sign * ACCELERATION * delta
		detached = true
		
	if detached:
		self.state = PLAYER_STATE.MOVING
		
func wall_slide_jump_check():
	if Input.is_action_just_pressed("ui_up"):
		play_jump_sfx()
		linear_velocity.x = -wall_collision_sign * MAX_HORIZONTAL_SPEED
		linear_velocity.y = -JUMP_SPEED
		self.state = PLAYER_STATE.MOVING
		
func apply_wall_slide_acceleration():
	linear_velocity.y = WALL_SLIDE_SPEED
	
func update_animations():
	var movement_sign = sign(input_vector.x)
	var gun_pointing_sign = sign(get_local_mouse_position().x)
	
	match state:
		PLAYER_STATE.MOVING:
			sprite.scale.x = gun_pointing_sign if gun_pointing_sign != 0 else sprite.scale.x
			
			if input_vector.x != 0:
				animator.play("Run")
				animator.playback_speed = movement_sign * gun_pointing_sign
			else:
				animator.play("Idle")
				animator.playback_speed = 1
				
			if not is_on_floor():
				animator.play("Jump")
				
		PLAYER_STATE.WALL_SLIDING:
			sprite.scale.x = -wall_collision_sign if wall_collision_sign != 0 else sprite.scale.x
			animator.play("WallSlide")
			
func play_jump_sfx():			
	SFX.play("Jump", -14, rand_range(0.8, 1.1))
# knockback effect
func _on_PlayerGun_missile_fired(missile_velocity):
	linear_velocity += -missile_velocity * 0.4

func get_save_data():
	return SaveSystem.get_basic_save_data(self)

func _on_PlayerStatsManager_player_died():
	queue_free()
	var _error = get_tree().change_scene("res://Scenes/UI/Menus/GameOverMenu.tscn")
