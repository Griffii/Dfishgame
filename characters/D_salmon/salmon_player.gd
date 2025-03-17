extends CharacterBody2D

@onready var sprite: Sprite2D = $salmon_sprite  # Changed from Sprite2d cause this shit can move now
@onready var collision_shape_player: CollisionShape2D = $CollisionShape_Player
@onready var swimming_state = $PlayerState/Swimming
@onready var flopping_state = $PlayerState/Flopping
var current_state: PlayerState = null


 ####### Internal Variables ####################################################
#var direction = Vector2.ZERO            
var facing_direction: float = 1.0        # Last direction faced (Left or Right | Only updates when directoin is )
var is_on_ground: bool = false
var is_in_water = false
var is_in_waterfall = false
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
	print("Player entered water.")
	is_in_water = true
	just_exited_water = false
	change_state(swimming_state)

func exit_water():
	print("Player left water.")
	is_in_water = false
	just_exited_water = true
	change_state(flopping_state)


func enter_waterfall():
	is_in_waterfall = true

func exit_waterfall():
	is_in_waterfall = false
