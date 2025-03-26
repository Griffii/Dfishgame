extends Node2D

@export var fade_duration := randf_range(4.0, 8.0)  # Time (seconds) to fade out
@onready var sprite := $Sprite2D
var fade_timer := 0.0

func _process(delta):
	if fade_timer < fade_duration:
		fade_timer += delta
		var t = clamp(1.0 - (fade_timer / fade_duration), 0.0, 1.0)
		sprite.modulate.a = t  # Only change alpha
	else:
		queue_free()
