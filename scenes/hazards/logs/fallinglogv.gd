extends RigidBody2D

@export var despawn_height: float = 1000.0  # Adjust this based on your screen size

func _process(delta):
	# If the log falls too far, remove it
	if global_position.y > despawn_height:
		queue_free()
