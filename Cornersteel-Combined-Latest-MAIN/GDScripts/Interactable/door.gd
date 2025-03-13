extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERFACE SETTINGS")
@export var prompt_message = "DOOR"

@export_category("ANIMATION SETTINGs")
@export var animation_speed : float = 3.0 # Speed at which the annimation plays
@export var is_door_flip : bool = false # Flag to check wether the door is flip or not

@onready var door_pivot := $DoorPivot # Reference to the door pivot node
@onready var audio_player := $AudioStreamPlayer3D # Reference to the audio player

var target_y_rotation : float = 0.0 # Tracks the current y rotation of the door
var is_door_close := true # flag to check if the door is open or not

func _on_interacted(body: Variant) -> void:
	toggle_door()
	
func _process(delta: float) -> void:
	animate_door(delta)
	
func toggle_door():
	if is_door_close:
		target_y_rotation = 90.0
		if is_door_flip:
			target_y_rotation = -90
	else:
		target_y_rotation = 0.0
		
	play_audio() # Plays the audio clip in the audio stream player
	is_door_close = !is_door_close # Update the door state
	
func animate_door(delta):
	# Only apply the rotation when the y rotation of the door is not equal to target y rotation
	if door_pivot.rotation_degrees.y != target_y_rotation:
		door_pivot.rotation_degrees.y = lerp(
			door_pivot.rotation_degrees.y, target_y_rotation, animation_speed * delta)
			
			
func play_audio():
	audio_player.play()
