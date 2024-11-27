extends Node3D

@export var respawn : bool = true
@export var respawn_delay : float = 2.0
@onready var platform_tilting_collision_shape_3d: CollisionShape3D = %"platform-tilting_collisionShape3D"
@onready var tilt_container: Node3D = $"tilt-container"
@onready var falling_platform_animation_player: AnimationPlayer = $FallingPlatformAnimationPlayer

var tilting := false
var current_rotation = 0
var rotate_force = 1
var rotation_dest = 50
var respawn_sequence_started : bool = false


func _process(delta):
	current_rotation = rad_to_deg(tilt_container.rotation.x)
	if tilting && current_rotation < rotation_dest:
		tilt_container.rotation.x += rotate_force * delta
		rotate_force += 0.2

func restore_platform() -> void:
	platform_tilting_collision_shape_3d.disabled = false
	visible = true
	respawn_sequence_started = false

func _on_body_entered(_body):
	if !tilting:
		Audio.play("res://sounds/fall.ogg") # Play sound
		scale = Vector3(1.25, 1, 1.25) # Animate scale
		print("hello")
		
	tilting = true
