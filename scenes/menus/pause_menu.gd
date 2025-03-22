extends MarginContainer


func _on_play_button_pressed() -> void:
	get_parent().pause_game()


func _on_reset_button_pressed() -> void:
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_parent().pause_game() # Unpause then load main menu
	SceneManager.swap_scenes("res://scenes/menus/main_menu.tscn", null, get_parent().root_node, "no_transition")
