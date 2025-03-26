extends RigidBody2D

@export var float_strength: float = -100.0
#@export var buoyancy: Vector2 = Vector2(0,-1200)   # Used for apply_force() / Kinda buggy
@export var water_drag: float = 2.0                 # Horizontal velocity damping
@export var rotation_recovery_speed: float = 10.0   # How fast the log rotates back to 0°
@export var gravity_normal: float = 0.3
@export var gravity_in_water: float = 0.1

var water_surface_y: float = 0.0
var is_in_water = false


func _physics_process(delta):
	if is_in_water:
		# Float to surface
		if global_position.y > water_surface_y:
			linear_velocity.y = move_toward(linear_velocity.y, float_strength, 200.0 * delta)
		
		# Apply horizontal water drag (X slows over time)
		linear_velocity.x = move_toward(linear_velocity.x, 0, water_drag * delta)
		# Smoothly rotate back to 0 (flat on water)
		rotation = move_toward(rotation, 0, rotation_recovery_speed * delta)



func enter_water(surface_y: float):
	is_in_water = true
	water_surface_y = surface_y
	#Half the speed of the log when entering water to simulate resistance
	linear_velocity.y = linear_velocity.y * 0.5
	gravity_scale = gravity_in_water


func exit_water():
	is_in_water = false
	gravity_scale = gravity_normal
