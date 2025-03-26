extends Level

@onready var narrator_dialogue_box = $Dialogue_Manager/Dialogue_Container/Narrator_Dialogue_Box
@export var dialogue_json = Resource
@onready var dialogue_data := {}

var current_checkpoint: Node2D
var camera_right_limit = 5500
var camera_top_limit = -4095


func _ready() -> void:
	# Set spawn node as checkpoint
	current_checkpoint = $Checkpoint_Container/Spawn
	# Remove any coins that were previously collected
	setup_level($Coin_Container)
	
	# Read the json file to get an array of all dialogues for the level
	if dialogue_json:
		var file = FileAccess.open(dialogue_json.resource_path, FileAccess.READ)
		if file:
			var json_text = file.get_as_text()
			var parsed = JSON.parse_string(json_text)
			if parsed:
				dialogue_data = parsed
			else:
				push_error("Failed to parse JSON: " + json_text)
		else:
			push_error("Could not open dialogue JSON file.")



func _on_end_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.load_next_level(level_name, true)



# Once the checkpoint area is entered, move checkpoint reference to checkpoint 01 node
func _on_checkpoint_01_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_01


func _on_checkpoint_02_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_02


func _on_narrator_01_trigger_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		pass
		#Dialogic.start("res://dialogue/dialogic_timelines/tutorial_timeline.dtl")
		# Disable trigger so it can't fire again
		#$Dialogue_Manager/Trigger_Container/Narrator_01_Trigger.disconnect("body_entered", Callable(self, "_on_narrator_01_trigger_body_entered"))
