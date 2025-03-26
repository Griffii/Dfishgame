extends Control

@onready var label = $MarginContainer/NinePatchRect/MarginContainer/Label
@export var label_text := ""

var current_convo: Array = []
var line_index := 0
var in_dialogue := false

func _ready() -> void:
	self.hide()
	label.text = label_text
	set_process_input(false)

func set_text(text: String):
	label_text = text
	label.text = label_text

func start_dialogue(conversation: Array):
	self.show()
	current_convo = conversation
	line_index = 0
	in_dialogue = true
	set_process_input(true)
	show_line()

func show_line():
	if line_index < current_convo.size():
		var line = current_convo[line_index]
		set_text(line.get("text", ""))
		# You could also update speaker, theme, portrait, etc here
	else:
		end_dialogue()

func _input(event):
	if in_dialogue and event.is_action_pressed("menu_accept"):
		line_index += 1
		show_line()

func end_dialogue():
	self.hide()
	in_dialogue = false
	set_process_input(false)
	set_text("")  # Clear label or hide dialogue box
	# Optionally emit a signal here to notify the level scene
	
