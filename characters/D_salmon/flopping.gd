extends PlayerState

@export var jump_force: float = -500.0  # Strength of jump when flopping
@export var gravity: float = 980.0  # Gravity when out of water
@export var acceleration: float = 200.0  # How fast the fish speeds up in air
@export var deceleration: float = 300.0  # How fast the fish slows down in air
@export var max_fall_speed: float = 500.0  # Cap falling speed
@export var max_air_speed: float = 100.0  # Maximum air speed
@export var ground_friction: float = 700.0  # Strong deceleration on landing
@export var jump_buffer_time: float = 0.2  # Allows buffering jumps before landing
@export var min_jump_force: float = -50.0  # Minimum jump force for short jumps
@export var rotation_speed: float = 300.0  # Degrees per second rotation in air

var jump_held: bool = false  # Tracks if jump key is still held
var jump_buffer_timer: float = 0.0  # Timer to track buffered jump input

func enter():
	player.velocity.y = jump_force  # Apply jump force on entry
	jump_held = true  # Start jump buffer tracking
	jump_buffer_timer = 0.0  # Reset buffer timer

func physics_process(delta):
	flopping(delta)
	player.move_and_slide()

func flopping(delta):
	# Apply gravity
	player.velocity.y += gravity * delta
	player.velocity.y = min(player.velocity.y, max_fall_speed)  # Cap fall speed
	
	# Store jump input in buffer if pressed
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time  # Reset buffer timer
	
	# Reduce jump height if jump is released early (variable jump height)
	if jump_held and not Input.is_action_pressed("jump"):
		player.velocity.y = max(player.velocity.y, min_jump_force)
		jump_held = false  # Stop applying extra jump force
	
	# Left/Right Movement with Acceleration & Deceleration
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction = 1
	elif Input.is_action_pressed("move_left"):
		direction = -1
	
	if direction != 0:
		# Accelerate towards movement direction
		player.velocity.x = move_toward(player.velocity.x, direction * max_air_speed, acceleration * delta)
		player.facing_direction = direction  # Update facing direction
	else:
		# Apply air deceleration when no input
		player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
	
	# Apply Rotation While in Air
	if not player.is_on_floor():
		player.rotation_degrees += direction * rotation_speed * delta  # Rotate based on direction
	
	# Instant deceleration when hitting the ground
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, ground_friction * delta)
		
		# Process jump buffer - allow jump if input was pressed shortly before landing
		if jump_buffer_timer > 0:
			player.velocity.y = jump_force  # Execute buffered jump
			jump_held = true
			jump_buffer_timer = 0  # Reset buffer
			
		# Allow another flop (jump) if touching the ground
		elif Input.is_action_just_pressed("jump"):
			player.velocity.y = jump_force  # Launch again
			jump_held = true  # Reset jump buffer tracking
	
	#### No directional control. You're a dang fish ############
	# Flip horizontally when moving left or right
	#if player.facing_direction != 0:
		#player.sprite.flip_h = player.facing_direction < 0  # True if left, False if right
	
	# Return to swimming if back in water
	if player.is_in_water:
		player.change_state(player.swimming_state)
	
	# Decrease jump buffer timer over time
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
