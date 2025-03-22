extends CharacterBody2D

@onready var sprite: Sprite2D = $salmon_sprite  # Changed from Sprite2d cause this shit can move now
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player
@onready var water_detector: Area2D = $Water_Detector
@onready var dry_out_overlay = $CanvasLayer/DryOutOverlay 
@onready var game_ui  = $CanvasLayer/In_Game_UI
@onready var camera = $Camera2D
@onready var respawn_timer = $RespawnTimer
@onready var swimming_state = $PlayerState/Swimming
@onready var flopping_state = $PlayerState/Flopping
@onready var dead_state = $PlayerState/Dead
var root_node

@export var dry_out_time: float = 20.0

####### Internal Variables ####################################################  
var current_state: PlayerState = null         
var facing_direction: float = 1.0
var is_on_ground = false
var is_in_water = false
var is_in_waterfall = false
var is_in_current = false
var just_exited_water = false
var dry_timer: float = 0.0  # Tracks remaining time before death
var is_paused = false
################################################################################

##### SFX ######################################################################
@onready var splat_sfx_01: AudioStreamPlayer2D = $Audio_Controller/wet_splat_sfx_01
################################################################################



func _ready() -> void:
	##print("D Fish Spawned in!")
	dry_timer = dry_out_time
	change_state(flopping_state)
	# Set root node for the UI menus
	root_node = get_parent()
	# Set camera right limit based on level - Add other limits ass levels recquire them
	camera.limit_right = root_node.camera_right_limit


func _physics_process(delta: float) -> void:
	if is_paused:
		return
	
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

## Logic for entering exiting water
func enter_water():
	if not is_in_water:  # Only update if not already in water
		is_in_water = true
		just_exited_water = false
		change_state(swimming_state)
func exit_water():
	# Only exit water if not inside a waterfall or other water body (prevents false flopping)
	if not is_in_waterfall:
		is_in_water = false
		just_exited_water = true
		change_state(flopping_state)

## Logic for entering exiting waterfalls
func enter_waterfall():
	is_in_waterfall = true
	enter_water()  # Ensure the player stays in water when entering a waterfall
func exit_waterfall():
	is_in_waterfall = false
	# Only exit water if NOT still in a water area (fixes waterfall-to-water bug)
	if not water_detector.has_overlapping_areas():
		exit_water()

## Logic for entering exiting water with strong currents
func enter_current():
	is_in_current = true
func exit_current():
	is_in_current = false


## Logic for being out of water
func drying_out(delta):
	# If already dead do nothing
	if current_state != dead_state:
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

func play_landing_sound(velocity_y: float):
	var landing = AudioStreamPlayer2D.new()
	landing.stream = splat_sfx_01.stream
	landing.bus = splat_sfx_01.bus
	landing.global_position = global_position
	
	# Random pitch (slightly faster or slower sound)
	landing.pitch_scale = randf_range(0.8, 1.1)
	
	# Volume based on impact speed (use abs because velocity.y is negative when falling)
	var fall_speed = abs(velocity_y)
	var base_volume = 0.0  # base quiet volume in dB
	var velocity_factor = clamp(fall_speed / 900.0, 0.0, 1.0)  # normalize between 0 and 1
	landing.volume_db = base_volume + lerp(0.0, 10.0, velocity_factor)  # louder with harder falls
	
	get_tree().root.add_child(landing)
	landing.play()
	
	await get_tree().create_timer(landing.stream.get_length()).timeout
	landing.queue_free()


## Logic for respawning player to a node location
func respawn():
	change_state(flopping_state)
	reset_drying_timer()
	global_position = root_node.current_checkpoint.position

## Logic for UI management
func toggle_paused():
	is_paused = !is_paused

func _on_respawn_timer_timeout():
	respawn()
