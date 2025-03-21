extends Node2D


func _on_end_area_body_entered(body: Node2D) -> void:
	SceneManager.swap_scenes("res://scenes/menus/main_menu.tscn", null, self, "no_transition")
