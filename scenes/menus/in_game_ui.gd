extends Control

@export var pause_menu: MarginContainer


func toggle_visibility(object):
	object.visible = !object.visible

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		toggle_visibility(pause_menu)
