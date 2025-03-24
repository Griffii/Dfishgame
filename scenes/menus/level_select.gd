extends Node

@onready var level_grid := $ScrollContainer/LevelGrid

func _ready():
	var data = SceneManager.load_level_data()
	var levels = data.get("levels", [])
	
	for level in levels:
		var level_name = level.get("level_name", "???")
		var is_completed = level.get("is_completed", false)
		var scene_path = level.get("scene_path", "")
		
		# Create button
		var button = Button.new()
		button.text = level_name
		button.custom_minimum_size = Vector2(150, 80)
		
		# Create style for normal state
		var style = StyleBoxFlat.new()
		if is_completed:
			style.bg_color = Color.RED
		else:
			style.bg_color = Color.BLUE
			
		style.set_corner_radius_all(12)
		style.content_margin_left = 10
		style.content_margin_right = 10
		style.content_margin_top = 6
		style.content_margin_bottom = 6
		
		# Create hover and pressed styles
		var hover_style = style.duplicate()
		hover_style.bg_color = style.bg_color.lightened(0.15)
		
		var pressed_style = style.duplicate()
		pressed_style.bg_color = style.bg_color.darkened(0.2)
		
		
		# Connect pressed signal to load the scene
		button.pressed.connect(func():
			SceneManager.swap_scenes(scene_path, null, self, "no_transition")
		)
		
		# Add to grid container
		level_grid.add_child(button)
