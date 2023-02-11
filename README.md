# Metroidvania Game
Godot 3.5.x

A basic game made in Godot, following the course: https://heartbeast-gamedev-school.teachable.com/p/1-bit-godot-course

## Table of Contents
- [Metroidvania Game](#metroidvania-game)
	- [Table of Contents](#table-of-contents)
	- [Screenshots](#screenshots)
	- [Player Movement](#player-movement)
	- [Player Animations](#player-animations)
	- [Camera following Player](#camera-following-player)
  
## Screenshots


## Player Movement

- Get the player input, in this case we only care about the X axis, the jump/gravity will take care of Y axis.
- Apply the horizontal acceleration based on input.
- Apply friction to damp the movement when no player input is happening.
- Check if jumping, and apply the jump force to the movement.
  - Detect mid jump release of jump input, to interrupt the jump and let players adjust jump height.
- Apply gravity.
-  Lastly, move the kinetic rigid body based on the movement calculation.
  - Use `move_and_slide` to allow sliding over other rigid bodies.

```py
func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	move()
```

```py
func get_input_vector() -> Vector2:
	var vec = Vector2.ZERO
	vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return vec
```
	
```py
func apply_horizontal_force(input_vector: Vector2, delta: float):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		
func apply_friction(input_vector: Vector2):
	if is_on_floor() and input_vector.x == 0:
		motion.x = lerp(motion.x, 0, FRICTION) 
```
		
```py
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
```

```py
func apply_gravity(delta: float):
#	if not is_on_floor():
	motion.y += GRAVITY * delta
	motion.y = min(motion.y, JUMP_FORCE)
```
	
```py
# if colliding with other rigid bodies, it will prevent movement
# returns the "leftover" motion, to be able to slide over other rigid bodies
func move():
	var ground_normal = Vector2.UP
	motion = move_and_slide(motion, ground_normal)
```

## Player Animations

- Create `Idle`, `Run` and `Jump` animations.
- Play the corresponding animation depending on the action.

```py
func update_animations(input_vector: Vector2):
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
		animator.play("Run")
	else:
		animator.play("Idle")
		
	if not is_on_floor():
		animator.play("Jump")
```

## Camera following Player

- Use a `RemoteTransform` in the `Player` scene.
- Setup a `Camera2D` in the main scene
  - Mark the Player scene as `Editable Children`
  - Assign the Camera to the node path in the `RemoteTransform` inside the `Player`
  - Mark the Camera to have smoothness in the movement.