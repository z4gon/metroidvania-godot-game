extends Enemy

class_name WalkingEnemy

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1
}

export (DIRECTION) var INITIAL_WALK_DIRECTION = DIRECTION.RIGHT

var walk_direction: int

onready var sprite = $Sprite
onready var ray_cast_floor_left = $RayCastFloorLeft
onready var ray_cast_floor_right = $RayCastFloorRight
onready var ray_cast_wall_left = $RayCastWallLeft
onready var ray_cast_wall_right = $RayCastWallRight

# ground and snapping
export (int) var MAX_SLOPE_ANGLE = 46
var ground_normal = Vector2.UP
var stop_on_slope = true
var max_slides = 4
var snap_vector = Vector2.DOWN

func _ready():
	walk_direction = INITIAL_WALK_DIRECTION
	
func _physics_process(_delta):
	apply_horizontal_velocity()
	update_walk_direction()
	update_animation()
	move()
	
func apply_horizontal_velocity():
	match walk_direction:
		DIRECTION.RIGHT:
			linear_velocity.x = MAX_SPEED
		DIRECTION.LEFT:
			linear_velocity.x = -MAX_SPEED

func update_walk_direction():
	match walk_direction:
		DIRECTION.RIGHT:
			if ray_cast_wall_right.is_colliding() or not ray_cast_floor_right.is_colliding():
				walk_direction = DIRECTION.LEFT
		DIRECTION.LEFT:
			if ray_cast_wall_left.is_colliding() or not ray_cast_floor_left.is_colliding():
				walk_direction = DIRECTION.RIGHT

func update_animation():
	sprite.scale.x = sign(linear_velocity.x)
	
func move():
	linear_velocity = move_and_slide_with_snap(
		linear_velocity, 
		snap_vector,
		ground_normal, 
		stop_on_slope,
		max_slides,
		deg2rad(MAX_SLOPE_ANGLE)
	)
