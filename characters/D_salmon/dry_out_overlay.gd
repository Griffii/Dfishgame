extends ColorRect

@export var max_alpha: float = 0.8  # Maximum darkness (0.0 - 1.0)
@export var fade_start_time: float = 10.0  # When the effect starts showing

func update_effect(dry_timer):
	if dry_timer > fade_start_time:
		modulate.a = 0.0  # Keep fully invisible until the timer reaches 10 seconds
	else:
		# Normalize dry_timer so that at 10 seconds it starts at 0 and at 0 seconds it reaches 1
		var normalized_time = 1.0 - (dry_timer / fade_start_time)
		var alpha = normalized_time * max_alpha  # Scale the fade effect
		modulate.a = clamp(alpha, 0.0, max_alpha)  # Ensure it stays within bounds
