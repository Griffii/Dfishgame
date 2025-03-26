extends Control
class_name LoadingScreen

signal transition_is_complete

@export var animation_player: AnimationPlayer
@export var progress_bar: ProgressBar
@export var timer: Timer

var starting_animation_name : String

func _ready() -> void:
	pass
	##progress_bar.visible = false

func start_transition(animation_name:String):
	pass

func finish_transition():
	queue_free()

func report_midpoint():
	transition_is_complete.emit()

func _on_timer_timeout() -> void:
	pass
	#progress_bar.visible = true

func update_bar(val:float) -> void:
	pass
	#progress_bar.value = val
