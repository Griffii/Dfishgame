extends Node2D

var current_checkpoint: Node2D
var camera_right_limit = 6125
var camera_top_limit = -4095


func _ready() -> void:
	# Set spawn node as checkpoint
	current_checkpoint = $Checkpoint_Container/Spawn


func _process(delta: float) -> void:
	pass

## Level Transition Trigger
func _on_end_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.swap_scenes("res://scenes/menus/main_menu.tscn", null, self, "no_transition")

## Checkpoint Adjustment Logic
func checkpoint01(body: Node2D):
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_01
func checkpoint02(body: Node2D):
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_02
func checkpoint03(body: Node2D):
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_03
func checkpoint04(body: Node2D):
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_04
func checkpoint05(body: Node2D):
	if body is CharacterBody2D:
		current_checkpoint = $Checkpoint_Container/Checkpoint_05
