extends Area2D

@onready var labels := $Labels

func _ready():
	labels.hide()
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		labels.show()

func _on_body_exited(body):
	if body is CharacterBody2D:
		labels.hide()
