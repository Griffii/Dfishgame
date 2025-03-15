extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player



# Movement and physics variables
@export var acceleration: float = 800.0
@export var deceleration: float = 600.0
@export var air_control: float = 0.5              # Reduce movement control in the air

@export var jump_force: float = -350.0            # Jump height
@export var gravity: float = 980.0                # Gravity force
@export var max_fall_speed: float = 600.0         # Max fall speed

@export var jump_buffer_duration: float = 0.15    # Time window for jump buffer
@export var jump_cutoff_multiplier: float = 0.5   # Multiplier to reduce jump height if key is released early
@export var coyote_time_duration: float = 0.1     # Time window for coyote jump

 ####### Internal Variables ########
var speed : float = 200         # Current player speed
var direction: float = 0.0               # Current input_direction as a float
var facing_direction: float = 1.0        # Last direction faced (Left or Right | Only updates when directoin is )
var is_on_ground: bool = false

var coyote_time: float = 0.0
var jump_buffer: float = 0.0

#####################################


func _physics_process(delta: float) -> void:
	# Call functions for movement, jumping, timers, pushing
	move_player(delta)      # Moves the player depending on input
	gravity_and_jump(delta) # Apply gravity, manage jump input
	update_timers(delta)    # Timers for coyote time / jump buffer
	#push_colliders()        # Apply force to collision objects (Push things)
	
	
	# Update the ground status
	move_and_slide()
	is_on_ground = is_on_floor()


func move_player(delta):
	# Get left or right input
	var input_direction: float = 0.0
	if Input.is_action_pressed("move_right"):
		input_direction += 1
	if Input.is_action_pressed("move_left"):
		input_direction -= 1
	
	# Set character facing direction after every input incase it's needed
	if input_direction != 0 && facing_direction != input_direction:
		facing_direction = input_direction
	
	# Apply player input control
	if input_direction != 0:
		# Move character in input direction with acceleration
		direction = input_direction
		velocity.x = move_toward(velocity.x, input_direction * speed, acceleration * delta)
		
		# Apply air control if character is in the air
		if not is_on_ground:
			velocity.x = lerp(velocity.x, input_direction * speed, air_control * delta)
	else:
		# Apply deceleration when no input is pressed
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	
	# Flip horizontally when moving left or right
	if facing_direction == 1:
		sprite.flip_h = false
	elif facing_direction == -1:
		sprite.flip_h = true


func gravity_and_jump(delta):
	# Apply gravity and limit fall speed
	if not is_on_ground:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	
	# Coyote time: Allows jumping shortly after leaving the ground
	if is_on_ground:
		coyote_time = coyote_time_duration
	
	# Jump buffer: Allows jump input to be buffered
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_duration
	
	# Jumping logic
	if coyote_time > 0 and jump_buffer > 0:
		velocity.y = jump_force
		coyote_time = 0.0
		jump_buffer = 0.0
	
	# Jump cutoff logic (reduce jump height if jump button is released early)
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cutoff_multiplier



func update_timers(delta: float) -> void:
	# Update temporary timers every delta
	if coyote_time > 0:
		coyote_time -= delta
	if jump_buffer > 0:
		jump_buffer -= delta
