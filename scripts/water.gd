extends Node2D

func _ready():
	$WaterArea.body_entered.connect(_on_body_entered)
	$WaterArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):  # Use groups to detect the player
		body.enter_water()

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.exit_water()
