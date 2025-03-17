extends Node2D

@onready var water_rect = $ColorRect 

func _ready():
	$WaterArea.body_entered.connect(_on_body_entered)
	$WaterArea.body_exited.connect(_on_body_exited)
	
	if water_rect.material:
		var unique_material = water_rect.material.duplicate()  # Force duplication
		water_rect.material = unique_material  # Apply new material
		print("Applied unique material to:", name)  # Debugging

func _on_body_entered(body):
	if body.is_in_group("player"):  # Use groups to detect the player
		body.enter_water()

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.exit_water()
