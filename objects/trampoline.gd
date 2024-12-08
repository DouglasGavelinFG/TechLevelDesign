extends Node3D
@export var trampoline_strength : float = 13
@onready var trampoline_audio_stream_player_3d: AudioStreamPlayer3D = $TrampolineAudioStreamPlayer3D
@onready var trampoline_animation_player: AnimationPlayer = $TrampolineAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("bounce_player"):
		body.bounce_player(trampoline_strength)
		trampoline_audio_stream_player_3d.play()
		trampoline_animation_player.play("bounce")
