class_name MainMenu extends Control

@onready var sfx_click: AudioStreamPlayer2D = $Audio_Controller/sfx_click


func _ready() -> void:
	pass
	##AudioGlobal.current_area = "MainMenu"


func _on_play_pressed() -> void:
	# Switch to main scene
	sfx_click.play()
	#get_tree().change_scene_to_file("res://Levels/tutorial_level.tscn")
	SceneManager.swap_scenes("res://scenes/levels/level_1-1.tscn", null, self, "no_transition")

func _on_options_pressed() -> void:
	sfx_click.play()

func _on_quit_pressed() -> void:
	# Close the .exe
	sfx_click.play()
	get_tree().quit()
