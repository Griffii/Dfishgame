extends PlayerState

@export var gravity: float = 1200.0  # Gravity applied to the dead player
@export var max_fall_speed: float = 800.0  # Terminal velocity

func enter():
	pass

func exit():
	pass
	# Reset the screen effect when leaving DeadState
	#if player.dry_out_overlay:
		#player.dry_out_overlay.update_effect(player.dry_out_time)  # Fully reset the overlay

func physics_process(delta):
	# Apply gravity, making the player fall naturally
	player.velocity.y = min(player.velocity.y + gravity * delta, max_fall_speed)
	
	player.move_and_slide()  # Let physics handle movementa
	
	# Optional: If needed, rotate the player slightly for dramatic effect
	player.rotation_degrees = move_toward(player.rotation_degrees, 0, 100 * delta)  # Fall sideways
