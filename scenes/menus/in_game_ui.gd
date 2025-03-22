extends Control

@export var player: CharacterBody2D
@export var pause_menu: MarginContainer
@export var settings_menu: MarginContainer

var root_node

func set_scene_root(root):
	if root is Node2D || root is Control || root is Node:
		root_node = root
		##print("Current root node is: ", root_node)

func toggle_visibility(object):
	object.visible = !object.visible

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		pause_game()

func pause_game():
	toggle_visibility(pause_menu)
	player.toggle_paused() 
