extends Node2D

var velocity = 0
var force = 0
var height = 0
var target_height = 0

var index = 0
var motion_factor = 0.01

signal splash

@onready var collision = $Area2D/CollisionShape2D
@onready var water_splash = $Water_Splash/ClipArea/GPUParticles2D
@onready var splash_sfx_template = $Audio_Controller/splash_sfx  # used as a template (stream, bus, etc.)

## This function applies Hooke's Law force to the spring
func water_update(spring_constant, dampening):
	height = position.y
	var loss = -dampening * velocity
	var x = height - target_height
	# Hooke's Law
	force = -spring_constant * x + loss
	velocity += force
	position.y += velocity

func initialize(x_position, id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	var extents = collision.shape.size
	var new_extents = Vector2(value / 2, extents.y)
	collision.shape.size = new_extents

func _on_area_2d_body_entered(body) -> void:
	if body is TileMapLayer:
		return
	
	var speed := 0.0
	
	if body is CharacterBody2D:
		speed = body.velocity.y * motion_factor
	elif body is RigidBody2D:
		speed = body.linear_velocity.y * (motion_factor / 2)
	else:
		return
		
	emit_signal("splash", index, speed)
	water_splash.restart()
	play_splash_sound(global_position)

# Spawn a one-shot audio player at the splash location
func play_splash_sound(at_position: Vector2) -> void:
	var sfx = AudioStreamPlayer2D.new()
	sfx.stream = splash_sfx_template.stream
	sfx.bus = splash_sfx_template.bus
	sfx.volume_db = splash_sfx_template.volume_db
	sfx.global_position = at_position
	
	# Add to root or this node's parent instead of current_scene
	get_tree().root.add_child(sfx)
	# Or: get_parent().add_child(sfx)
	
	sfx.play()
	
	var duration = sfx.stream.get_length()
	await get_tree().create_timer(duration).timeout
	sfx.queue_free()
