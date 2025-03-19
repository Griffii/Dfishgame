extends CharacterBody2D

@onready var sprite: Sprite2D = $salmon_sprite  # Changed from Sprite2d cause this shit can move now
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player
@onready var water_detector: Area2D = $Water_Detector
@onready var dry_out_overlay = $CanvasLayer/DryOutOverlay 
@onready var swimming_state = $PlayerState/Swimming
@onready var flopping_state = $PlayerState/Flopping
@onready var dead_state = $PlayerState/Dead
var current_state: PlayerState = null

@export var dry_out_time: float = 20.0

 ####### Internal Variables ####################################################           
var facing_direction: float = 1.0
var is_on_ground = false
var is_in_water = false
var is_in_waterfall = false
var is_in_current = false
var just_exited_water = false
var dry_timer: float = 0.0  # Tracks remaining time before death
################################################################################

func _ready() -> void:
	dry_timer = dry_out_time
	change_state(flopping_state)


func _physics_process(delta: float) -> void:
	check_drying_status(delta)
	# Call the process from the state machine
	if current_state:
		current_state.physics_process(delta)


func change_state(new_state: PlayerState):
	if current_state:
		current_state.exit()  # Exit old state
	current_state = new_state
	current_state.player = self  # Assign player reference
	current_state.enter()  # Enter new state


func enter_water():
	if not is_in_water:  # Only update if not already in water
		is_in_water = true
		just_exited_water = false
		change_state(swimming_state)
func exit_water():
	# Only exit water if not inside a waterfall (prevents false flopping)
	if not is_in_waterfall:
		is_in_water = false
		just_exited_water = true
		change_state(flopping_state)


func enter_waterfall():
	is_in_waterfall = true
	enter_water()  # Ensure the player stays in water when entering a waterfall
func exit_waterfall():
	is_in_waterfall = false
	# Only exit water if NOT still in a water area (fixes waterfall-to-water bug)
	if not water_detector.has_overlapping_areas():
		exit_water()


func enter_current():
	is_in_current = true
func exit_current():
	is_in_current = false

func drying_out(delta):
	if not is_in_water:
		dry_timer -= delta  # Reduce time if out of water
		dry_out_overlay.update_effect(dry_timer)  # Update screen effect
		
		if dry_timer <= 0:
			change_state(dead_state)  # Switch to dead state
	elif dry_timer != dry_out_time:
		reset_drying_timer()  # Reset timer only when necessary

func check_drying_status(delta):
	if is_in_water:
		reset_drying_timer()  # Reset timer if in water
	else:
		drying_out(delta)  # Start drying timer if out of water

func reset_drying_timer():
	dry_timer = dry_out_time  # Reset timer to full
	dry_out_overlay.update_effect(dry_timer) # Reset effect
