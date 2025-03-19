extends CharacterBody2D

@onready var sprite: Sprite2D = $salmon_sprite  # Changed from Sprite2d cause this shit can move now
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player
@onready var water_detector: Area2D = $Water_Detector
@onready var swimming_state = $PlayerState/Swimming
@onready var flopping_state = $PlayerState/Flopping
var current_state: PlayerState = null


 ####### Internal Variables ####################################################
#var direction = Vector2.ZERO            
var facing_direction: float = 1.0
var is_on_ground = false
var is_in_water = false
var is_in_waterfall = false
var is_in_current = false
var just_exited_water = false
################################################################################

func _ready() -> void:
	change_state(flopping_state)


func _physics_process(delta: float) -> void:
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
