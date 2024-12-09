extends Node3D
@onready var jewel_container: Node3D = $mesh_offset/jewel
@export var jewel_material : StandardMaterial3D
@export var activated_color : Color
var original_color : Color
var original_pos : Vector3
@onready var jewel_mesh: MeshInstance3D = $mesh_offset/jewel/jewel
var time := 0.0
var touched : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_mat = jewel_material.duplicate()
	jewel_mesh.set_surface_override_material(0,new_mat)
	original_color = new_mat.albedo_color
	original_pos = jewel_container.position

func _process(delta):
	if not touched:
		jewel_container.rotate_y(delta) # Rotation
		jewel_container.position.y += (cos(time * 3) * 1) * delta # Sine movement
		jewel_container.scale = lerp(jewel_container.scale, Vector3.ONE*2,delta*6)

		time += delta

	if touched:
		jewel_container.position = lerp(jewel_container.position,Vector3.ZERO,delta*2)
		jewel_container.scale = lerp(jewel_container.scale, Vector3.ONE,delta*6)

func switch_check(active : bool) -> void:
	touched = active
	if active:
		jewel_mesh.get_surface_override_material(0).albedo_color = activated_color
	else:
		jewel_mesh.get_surface_override_material(0).albedo_color = original_color
		jewel_container.position = original_pos
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("reached_checkpoint"):
		body.reached_checkpoint(global_position)
		var all_cps : Array[Node] = get_tree().get_nodes_in_group("Checkpoint")
		for check in all_cps:
			if check != self:
				check.switch_check(false)
			else:
				check.switch_check(true)
