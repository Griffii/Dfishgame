extends Node2D

var log_scene = preload("res://assets/logs/fallinglogh.tscn")  # Adjust path as needed

@export var spawn_interval: float = 2.0
@export var spawn_position_x: float = 0.0
@export var spawn_height: float = -100.0

@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_log)
	timer.start()
	print("Spawner ready! Timer set.")  # Debugging message

func spawn_log():
	print("Spawning a new log!")  # Debugging message
	var log = log_scene.instantiate()
	log.global_position = Vector2(spawn_position_x, spawn_height)
	add_child(log)
	print("Log spawned at: " + str(log.global_position))  # Debugging message
