extends PlayerState

@export var gravity: float = 1200.0  # Gravity applied to the dead player
@export var max_fall_speed: float = 800.0  # Terminal velocity
@export var respawn_timer: Timer
var is_flipped = false

func enter():
	respawn_timer.start()

func exit():
	# Reset sprite
	player.sprite.flip_v = false
	is_flipped = false
	
	if respawn_timer.is_stopped() == false:
		respawn_timer.stop()

func physics_process(delta):
	# Apply gravity, making the player fall naturally
	player.velocity.y = min(player.velocity.y + gravity * delta, max_fall_speed)
	
	player.move_and_slide()  # Let physics handle movementa
	
	# Optional:Rrotate the player for dramatic effect
	player.rotation_degrees = move_toward(player.rotation_degrees, 0, 100 * delta)
	
	# If laying flat and not already belly up, flip over - You dead b*tch
	if player.rotation_degrees == 0 && !is_flipped:
		player.sprite.flip_v = true
		is_flipped = true
