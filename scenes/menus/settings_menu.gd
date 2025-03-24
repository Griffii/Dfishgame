extends MarginContainer

var parent_node

func _ready() -> void:
	parent_node = get_parent()


func _on_reset_levels_data_button_pressed():
	SceneManager.reset_all_levels()
	parent_node.toggle_visibility(parent_node.settings_menu)
	parent_node.toggle_visibility(parent_node.pause_menu)


func _on_go_back_button_pressed():
	parent_node.toggle_visibility(parent_node.settings_menu)
	parent_node.toggle_visibility(parent_node.pause_menu)
