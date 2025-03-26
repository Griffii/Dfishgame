extends Level

var current_checkpoint: Node2D

var camera_right_limit = 6300
var camera_top_limit = null

func _ready() -> void:
	# Set spawn node as checkpoint
	current_checkpoint = $Checkpoint_Container/Spawn
	# Set up level coins
	call_deferred("setup_level", $Coin_Container)

func _on_end_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.load_next_level(level_name, true)

# Once the checkpoint area is entered, move checkpoint reference to checkpoint 01 node
func _on_checkpoint_01_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_01
