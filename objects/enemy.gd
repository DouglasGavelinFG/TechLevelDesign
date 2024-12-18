extends CharacterBody3D

@onready var animation = $Body/AnimationPlayer

# Enemy properties
@export var speed: float = 5.7
@export var acceleration: float = 10
@export var gravity: float = 9.8
var target_view: Vector3 = Vector3.ZERO
var idle = true
var player: Node3D = null

func _ready() -> void:
	# Find the player node (adjust the path as needed)
	player = get_node("../Player")

func _physics_process(delta):
	if player && is_on_floor() && !idle:
		# Calculate the direction to the player
		var direction = Vector3(
			player.global_transform.origin.x - global_transform.origin.x,
			0,  # Ignore vertical direction
			player.global_transform.origin.z - global_transform.origin.z
		).normalized()
		
		# Smoothly accelerate toward the player
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = 0
		velocity.z = 0
	
	# Apply gravity to keep the enemy grounded
	velocity.y -= gravity * delta
	
	# Look at
	target_view = player.global_transform.origin
	target_view.y += 0.5 #add upwards tilt
	
	# Apply movement
	move_and_slide()
	look_at(target_view, Vector3.UP)
	
	if position.y < 0:
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		animation.play("blob", 0.1, 10)
		idle = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		animation.play("blob", 0.1, 1)
		idle = true
