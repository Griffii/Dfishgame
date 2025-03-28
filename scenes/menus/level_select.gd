extends Control

@onready var sfx_click: AudioStreamPlayer2D = $Audio_Controller/sfx_click
@onready var mouse_anchor: StaticBody2D = $MouseAnchor
@onready var level_grid := $MarginContainer/VBoxContainer/ScrollContainer/LevelGrid
const LEVEL_OVERVIEW_SCENE := preload("res://scenes/menus/level_overview_box.tscn") # Update path if needed

func _ready():
	# Hide the mouse - Use custom floppy fish as mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var data = SceneManager.load_level_data() # Returns a dictionary
	var levels = data.get("levels", []) # Returns an array full of dictionaries
	
	for level_data in levels: # For every dict in the array, pass that dict to the 
		##print("Passing this data to the level_overview_box scene: ", level_data)
		var level_overview = LEVEL_OVERVIEW_SCENE.instantiate()
		level_grid.add_child(level_overview)
		level_overview.set_level_data(level_data, self)

# Make the mouse anchor customer sprite follow the mouse
func _process(_delta):
	mouse_anchor.global_position = get_global_mouse_position()

func _on_back_button_pressed() -> void:
	sfx_click.play()
	SceneManager.swap_scenes("res://scenes/menus/main_menu.tscn", null, self, "no_transition")
