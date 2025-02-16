@tool
extends Node3D

@export var rotation_vector = 1
@export var rotation_speed = 0.005

var time = 0.0

var random_number = RandomNumberGenerator.new()

var random_velocity:float
var random_time:float

func _ready():
	
	random_velocity = random_number.randf_range(0.1, 2.0)
	random_time = random_number.randf_range(0.1, 2.0)

func _process(delta):
	
	#rotation.z += (cos(time * random_time) * random_velocity) * delta # Sine movement
	rotation[rotation_vector] += rotation_speed
	
	time += delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("enter_rotating_platform"):
		body.enter_rotating_platform()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("exit_rotating_platform"):
		body.exit_rotating_platform()
