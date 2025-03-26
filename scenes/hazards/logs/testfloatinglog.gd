extends RigidBody2D

@export var despawn_height: float = 1000.0  # Adjust based on your scene
@export var buoyancy: float = 1.5  # Strength of buoyant force
@export var drag: float = 0.2  # Slows movement in water

@onready var water: Node2D = $"../Water_Body"  # Adjust path if necessary
var water_level: float = INF  # Default to an unreachable value
var in_water: bool = false  # Track if object is in water

func _process(delta):
	# Despawn if it falls too far
	if global_position.y > despawn_height:
		queue_free()

	# Continuously update water level if water exists
	if water != null:
		water_level = water.global_position.y

	# Apply buoyancy and drag only when in water
	if in_water:
		var depth = global_position.y - water_level  # Depth below surface
		var force = -buoyancy * depth  # Buoyancy force
		apply_central_force(Vector2(0, force))

		# Apply drag only if submerged
		linear_velocity *= 1.0 - (drag * delta)

func _on_water_entered(water_body):
	water_level = water_body.global_position.y
	in_water = true  # Mark as in water

func _on_water_exited():
	in_water = false  # Mark as out of water
	water_level = INF  # Reset water level

func _on_waterdetector_body_entered(body: Node2D) -> void:
	if body.is_in_group("water"):  # Ensure it's water
		water_level = body.global_position.y
		in_water = true

func _on_waterdetector_body_exited(body: Node2D) -> void:
	if body.is_in_group("water"):
		in_water = false
		water_level = INF
