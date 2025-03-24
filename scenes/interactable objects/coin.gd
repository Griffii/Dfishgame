extends Node2D

@onready var coin_sfx = $coin_sfx

func _ready() -> void:
	if not is_in_group("uncollected"):
		add_to_group("uncollected")

func _on_coin_touched(body: Node2D) -> void:
	if body is CharacterBody2D && is_in_group("uncollected"):
		coin_sfx.play()                 # Play sfx
		self.visible = false            # Make invisible
		remove_from_group("uncollected")# Move to collected group
		add_to_group("collected")
