extends Node2D

@export var k = 0.015
@export var d = 0.03
@export var spread = 0.2

# The spring array
var springs = []
var passes = 12

# Distance in pixels between each spring
@export var distance_between_springs = 32
# Number of springs in the scene
@export var spring_number = 6

# Total water body length
var water_length = distance_between_springs * spring_number

# Spring scene reference
@onready var water_spring = preload("res://scenes/water_bodies/water_spring/water_spring.tscn")

# The body of water depth
@export var depth = 1000
var target_height = global_position.y
var bottom = target_height + depth

# References
@onready var water_polygon = $Water_Polygon
@onready var water_border = $Water_Border
@export var border_thickness = 1.1
@onready var collisionShape = $WaterArea/CollisionShape2D
@onready var water_body_area = $WaterArea

# Floating log reference
var floating_logs = []
@export var log_despawn_height: float = 1000.0

func _ready():
	$WaterArea.body_entered.connect(_on_water_entered)
	$WaterArea.body_exited.connect(_on_water_exited)
	
	water_border.width = border_thickness
	spread = spread / 1000
	
	for i in range(spring_number):
		var x_position = distance_between_springs * i
		var w = water_spring.instantiate()
		add_child(w)
		springs.append(w)
		w.initialize(x_position, i)
		w.set_collision_width(distance_between_springs)
		w.connect("splash", Callable(self, "splash"))
	
	var total_length = distance_between_springs * (spring_number - 1)
	var rectangle = RectangleShape2D.new().duplicate()
	var rect_position = Vector2(total_length / 2, depth / 2)
	var rect_extents = Vector2(total_length, depth)
	water_body_area.position = rect_position
	rectangle.size = rect_extents
	collisionShape.set_shape(rectangle)

func _physics_process(_delta):
	for i in springs:
		i.water_update(k, d)
	
	var left_deltas = []
	var right_deltas = []
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	
	new_border()
	draw_water_body()
	update_floating_logs()

func update_floating_logs():
	for log in floating_logs:
		var closest_spring = get_closest_spring(log.global_position.x)
		if closest_spring:
			var water_height = closest_spring.global_position.y
			if log.global_position.y > water_height:
				log.position.y = lerp(log.position.y, water_height, 0.1)
				log.velocity.y *= -0.5  # Reduce downward velocity
			if log.global_position.y > log_despawn_height:
				log.queue_free()
				floating_logs.erase(log)

func get_closest_spring(x_position):
	var closest_spring = null
	var min_distance = INF
	for spring in springs:
		var distance = abs(spring.global_position.x - x_position)
		if distance < min_distance:
			min_distance = distance
			closest_spring = spring
	return closest_spring

func draw_water_body():
	var curve = water_border.curve
	var points = Array(curve.get_baked_points())
	var water_polygon_points = points
	var first_index = 0
	var last_index = water_polygon_points.size()-1
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, depth))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, depth))
	water_polygon_points = PackedVector2Array(water_polygon_points)
	water_polygon.set_polygon(water_polygon_points)
	water_polygon.set_uv(water_polygon_points)

func new_border():
	var curve = Curve2D.new().duplicate()
	var surface_points = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	water_border.curve = curve
	water_border.smooth(true)
	water_border.queue_redraw()

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

func _on_water_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.enter_water()
	elif body.name == "testfloatinglog":
		floating_logs.append(body)
		body.velocity.y = -2.0  # Give a slight upward push when entering

func _on_water_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.exit_water()
	elif body.name == "testfloatinglog":
		floating_logs.erase(body)
