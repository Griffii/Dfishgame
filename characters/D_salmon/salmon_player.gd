extends CharacterBody2D

@onready var sprite: Sprite2D = $salmon_sprite  # Changed from Sprite2d cause this shit can move now
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player



# Movement and physics variables
@export var acceleration: float = 800.0
@export var deceleration: float = 600.0
@export var air_control: float = 0.5              # Reduce movement control in the air

@export var jump_force: float = -350.0            # Jump height
@export var gravity: float = 980.0                # Gravity force
@export var max_fall_speed: float = 600.0         # Max fall speed

@export var speed : float = 100                  # Land Speed of Fish
@export var swim_speed : float = 200             # Swim speed of fish
@export var water_drag: float = 0.9              # Slows movement in water
@export var float_force: float = 0.0             # Upward/Downward force in water
@export var sink_speed: float = 30.0              # How fast the fish sinks


@export var jump_buffer_duration: float = 0.15    # Time window for jump buffer
@export var jump_cutoff_multiplier: float = 0.5   # Multiplier to reduce jump height if key is released early
@export var coyote_time_duration: float = 0.1     # Time window for coyote jump

 ####### Internal Variables ########
#var direction = Vector2.ZERO            
var facing_direction: float = 1.0        # Last direction faced (Left or Right | Only updates when directoin is )
var is_on_ground: bool = false
var in_water: bool = false               # Tracks if the fish is in water

var coyote_time: float = 0.0
var jump_buffer: float = 0.0
#####################################


func _physics_process(delta: float) -> void:
	# Call functions for movement, jumping, timers, pushing
	if in_water:
		swim_movement(delta)
	else:
		move_player(delta)      # Moves the player depending on input
		gravity_and_jump(delta) # Apply gravity, manage jump input
		update_timers(delta)    # Timers for coyote time / jump buffer
	
	
	# Update the ground status
	move_and_slide()
	is_on_ground = is_on_floor()
	
	#update_animation() #we animated up in this bitch

### Swim Movements ###
func swim_movement(delta):
	# Apply smooth movement in water
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	
	# Left/Right Movement with Acceleration & Deceleration
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * swim_speed, acceleration * delta)
		facing_direction = direction.x  # Update facing direction
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)  # Decelerate if no input
	
	# Apply Vertical Movement
	if direction.y < 0:  # Moving up
		velocity.y = move_toward(velocity.y, direction.y * swim_speed, acceleration * delta)
	else:  # No upward input = apply sinking effect
		velocity.y = move_toward(velocity.y, sink_speed, deceleration * delta)
	
	# Flip horizontally when moving left or right
	if facing_direction != 0:
		sprite.flip_h = facing_direction < 0  # True if left, False if right


### Land Movement ###
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
		var direction = input_direction
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
	if not is_on_ground && not in_water:
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


func update_animation():
	if not is_on_ground:
		sprite.play("jumping")  # Play jumping animation when in the air
	elif abs(velocity.x) > 10:
		sprite.play("swimming")  # Play swimming when moving on the ground
	else:
		sprite.play("idle")  # Play idle when standing still



func enter_water():
	print("Player entered water.")
	in_water = true
	velocity.y = float_force  # Make fish float when entering water

func exit_water():
	print("Player left water.")
	in_water = false
