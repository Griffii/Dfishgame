extends Node2D


func _on_end_area_body_entered(body: Node2D) -> void:
	SceneManager.swap_scenes("res://scenes/levels/level_2-1.tscn", null, self, "no_transition")
