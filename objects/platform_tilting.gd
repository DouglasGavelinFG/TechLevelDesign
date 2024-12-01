extends Node3D

@onready var tilt_container: Node3D = $"tilt-container"
@onready var falling_platform_animation_player: AnimationPlayer = $FallingPlatformAnimationPlayer

var tilting = false
var tilting_restore = false
var entered_body = false
var pressure_count = 0
var max_pressure_count = 0.1
var current_rotation = 0
var tilt_force = 0
var tilt_degree = 60

func _process(delta):
	if entered_body:
		pressure_count += 1 * delta
	
	if pressure_count > max_pressure_count && !tilting && !tilting_restore:
		Audio.play("res://sounds/fall.ogg") # Play sound
		tilt_force = 0
		tilting = true
		
		await get_tree().create_timer(2).timeout
		tilt_up_platform()
	
	current_rotation = rad_to_deg(tilt_container.rotation.x)
	if tilting && current_rotation < tilt_degree:
		tilt_container.rotation.x += tilt_force * delta
		tilt_force += 0.5
	
	if tilting_restore && current_rotation > 0:
		tilt_container.rotation.x -= tilt_force * delta

func tilt_up_platform() -> void:
	if !tilting_restore:
		tilting = false
		tilting_restore = true
		tilt_force = 1
	
		await get_tree().create_timer(3).timeout
		tilting_restore = false

func _on_body_entered(body) -> void:
	if !entered_body:
		entered_body = true

func _on_body_exited(body) -> void:
	if entered_body:
		entered_body = false
		pressure_count = 0
