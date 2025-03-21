extends Node2D

var velocity = 0
var force = 0
var height = 0
var target_height = 0

var index = 0
var motion_factor = 0.01

signal splash

@onready var collision = $Area2D/CollisionShape2D

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
	var new_extents = Vector2(value/2, extents.y)
	
	collision.shape.size = new_extents


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is CharacterBody2D:
		var char_body = body as CharacterBody2D  # Cast to CharacterBody2D safely
		var speed = char_body.velocity.y * motion_factor
		emit_signal("splash", index, speed)
