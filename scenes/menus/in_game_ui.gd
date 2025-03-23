extends Control

@export var player: CharacterBody2D
@export var pause_menu: MarginContainer
@export var settings_menu: MarginContainer


func toggle_visibility(object):
	object.visible = !object.visible

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		pause_game()

func pause_game():
	toggle_visibility(pause_menu)
	player.toggle_paused() 
