extends Node2D

@export var scroll_speed := 30.0
@export var cloud_width := 960  # Width of one cloud sprite
@export var spacing := 0        # Optional gap between clouds

func _process(delta):
	for cloud in get_children():
		cloud.position.x -= scroll_speed * delta
		
		# If cloud has moved completely offscreen to the left...
		if cloud.global_position.x < -cloud_width:
			# ... move it to the right of the farthest cloud
			var rightmost = get_rightmost_cloud_x()
			cloud.position.x = rightmost + cloud_width + spacing

func get_rightmost_cloud_x() -> float:
	var max_x = -INF
	for cloud in get_children():
		max_x = max(max_x, cloud.global_position.x)
	return max_x
