extends CanvasLayer
@onready var level_complete: Label = %"Level Complete"
@onready var coins_label: Label = %CoinsLabel
@onready var play_again_button: Button = %PlayAgainButton
@onready var environment: WorldEnvironment = %Environment
@onready var time_label: Label = %TimeLabel
@onready var time_name_label: Label = %TimeNameLabel
@onready var controls: Label = %Controls

var original_blur : bool
var original_blur_distance : float
var original_blur_amount : float
var speed_run : bool
var seconds : float
var pause_timer : bool

func _ready() -> void:
	level_complete.visible = false
	play_again_button.visible = false
	time_label.visible = false
	time_name_label.visible = false

func _process(delta: float) -> void:
	if speed_run and not pause_timer:
		time_label.visible = true
		time_name_label.visible = true
		seconds += delta
		var minutes : String
		if (seconds / 60) > 1:
			var minutes_int : int = seconds / 60
			minutes = str(minutes_int) + " : "
		else:
			minutes = ""
		var leftover_seconds : String
		if (int(seconds) % 60) < 10:
			leftover_seconds = "0" + str(int(seconds) % 60)
		else:
			leftover_seconds = str(int(seconds) % 60)
		time_label.text = minutes + leftover_seconds

func start_speedrun():
	speed_run = true

func hide_controls():
	controls.visible = false

func _on_coin_collected(coins):
	get_tree().call_group("Door", "coin_amount_updated",coins)
	coins_label.text = str(coins)

func _on_player_reached_goal() -> void:
	original_blur = environment.camera_attributes.get("dof_blur_far_enabled")
	original_blur_distance = environment.camera_attributes.get("dof_blur_far_distance")
	original_blur_amount = environment.camera_attributes.get("dof_blur_amount")
	
	environment.camera_attributes.set("dof_blur_far_enabled", true)
	environment.camera_attributes.set("dof_blur_far_distance", 0.0)
	environment.camera_attributes.set("dof_blur_amount", 0.1)
	level_complete.visible = true
	play_again_button.visible = true
	if speed_run:
		pause_timer = true
	get_tree().paused = true


func _on_play_again_button_pressed() -> void:
	environment.camera_attributes.set("dof_blur_far_enabled", original_blur)
	environment.camera_attributes.set("dof_blur_far_distance", original_blur_distance)
	environment.camera_attributes.set("dof_blur_amount", original_blur_amount)

	get_tree().paused = false
	play_again_button.visible = false
	level_complete.visible = false
	coins_label.text = str(0)
	get_tree().reload_current_scene()
