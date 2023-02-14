extends Enemy

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1
}

export (DIRECTION) var INITIAL_WALK_DIRECTION = DIRECTION.RIGHT

var walk_direction: int

onready var ray_cast_floor = $RayCastFloor
onready var ray_cast_wall = $RayCastWall

func _ready():
	walk_direction = INITIAL_WALK_DIRECTION
	ray_cast_wall.cast_to.x *= walk_direction
	ray_cast_floor.rotation_degrees = -MAX_SPEED * walk_direction

func _physics_process(_delta):
	if ray_cast_wall.is_colliding():
		# when reaching a wall, slap on it and continue moving
		snap_to_surface(ray_cast_wall)
	else:
		if ray_cast_floor.is_colliding():
			snap_to_surface(ray_cast_floor)
		else:
			rotation_degrees += 20 * walk_direction
		
func snap_to_surface(ray_cast: RayCast2D):
	global_position = ray_cast.get_collision_point()
	var normal = ray_cast.get_collision_normal()
	rotation = normal.rotated(deg2rad(90)).angle()
