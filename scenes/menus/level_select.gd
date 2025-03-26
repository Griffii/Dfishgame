extends Node

@onready var level_grid := $MarginContainer/VBoxContainer/ScrollContainer/LevelGrid
const LEVEL_OVERVIEW_SCENE := preload("res://scenes/menus/level_overview_box.tscn") # Update path if needed

func _ready():
	var data = SceneManager.load_level_data() # Returns a dictionary
	var levels = data.get("levels", []) # Returns an array full of dictionaries
	
	for level_data in levels: # For every dict in the array, pass that dict to the 
		##print("Passing this data to the level_overview_box scene: ", level_data)
		var level_overview = LEVEL_OVERVIEW_SCENE.instantiate()
		level_grid.add_child(level_overview)
		level_overview.set_level_data(level_data)


func _on_back_button_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/menus/main_menu.tscn", null, self, "no_transition")
