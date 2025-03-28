extends Control

@onready var level_name_label = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/MarginContainer/LevelName
@onready var coin_counter_label = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/CoinCounter
@onready var completed_tint = $MarginContainer/NinePatchRect/CompletedTint
@onready var play_button = $MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/PlayButton

var level_data = {}
var parent_scene: Node

func _ready() -> void:
	level_name_label.text = "No Name"
	coin_counter_label.text = "0/0"


func set_level_data(level_dict, parent):
	parent_scene = parent
	level_data = level_dict
	level_name_label.text = level_data.get("level_name", "???")
	var uncollected = level_data.get("uncollected_coins", []).size()
	var collected = level_data.get("collected_coins", []).size()
	coin_counter_label.text = str(collected) + "/" + str(uncollected)
	if level_data.get("is_completed") == true:
		completed_tint.color = Color(0.0, 0.4, 1.0, 0.5)  # RGBA with 50% alpha
	
	# Connect button
	play_button.pressed.connect(_on_play_pressed)


func _on_play_pressed():
	if level_data.has("scene_path"):
		parent_scene.sfx_click.play()
		SceneManager.swap_scenes(level_data.get("scene_path"), null, parent_scene, "no_transition")
	else:
		push_error("Level is missing 'scene_path'")
