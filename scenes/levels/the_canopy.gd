extends Level

var current_checkpoint: Node2D
var camera_right_limit = 5500
var camera_top_limit = -4095

func _ready() -> void:
	# Set spawn node as checkpoint
	current_checkpoint = $Checkpoint_Container/Spawn
	# Remove any coins that were previously collected
	setup_level($Coin_Container)


func _on_kill_plane_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.explode()
