extends MarginContainer

var parent_node

func _ready() -> void:
	parent_node = get_parent()

func _on_play_button_pressed() -> void:
	parent_node.pause_game()

func _on_reset_button_pressed() -> void:
	parent_node.player.respawn()
	parent_node.pause_game()

func _on_settings_button_pressed() -> void:
	parent_node.toggle_visibility(parent_node.settings_menu)
	parent_node.toggle_visibility(parent_node.pause_menu)

func _on_quit_button_pressed() -> void:
	SceneManager.leave_level(SceneManager.current_level_node.level_name, false)
	get_parent().pause_game() # Unpause then load main menu
	SceneManager.swap_scenes("res://scenes/menus/main_menu.tscn", null, parent_node.player.root_node, "no_transition")
