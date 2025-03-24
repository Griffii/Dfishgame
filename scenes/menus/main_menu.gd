class_name MainMenu extends Control

@onready var sfx_click: AudioStreamPlayer2D = $Audio_Controller/sfx_click
@onready var mouse_anchor: StaticBody2D = $MouseAnchor
@export var main_menu: MarginContainer
@export var settings_menu: MarginContainer


func _ready() -> void:
	# Hide the mouse - Use custom floppy fish as mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	##AudioGlobal.current_area = "MainMenu"

# Make the mouse anchor customer sprite follow the mouse
func _process(delta):
	mouse_anchor.global_position = get_global_mouse_position()


func toggle_visibility(object):
	object.visible = !object.visible


func _on_play_pressed() -> void:
	# Switch to main scene
	sfx_click.play()
	# Unhide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Load level select screen
	SceneManager.swap_scenes("res://scenes/menus/level_select.tscn", null, self, "no_transition")

func _on_options_pressed() -> void:
	sfx_click.play()
	toggle_visibility(main_menu)
	toggle_visibility(settings_menu)

func _on_quit_pressed() -> void:
	# Close the .exe
	sfx_click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _on_reset_levels_data_button_pressed():
	sfx_click.play()
	SceneManager.reset_all_levels()
	toggle_visibility(main_menu)
	toggle_visibility(settings_menu)
