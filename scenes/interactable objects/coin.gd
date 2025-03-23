extends Node2D

@onready var coin_sfx = $coin_sfx

var is_collected = false

func _on_coin_touched(body: Node2D) -> void:
	if body is CharacterBody2D:
		if !is_collected:
			coin_sfx.play()                 # Play sfx
			self.visible = false            # Make invisible
			is_collected = true             # Disable collision
		else:
			self.queue_free()               # Despawn node upon second collection
