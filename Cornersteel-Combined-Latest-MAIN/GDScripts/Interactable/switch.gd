extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERFACE SETTINGS")
@export var prompt_message = "SWITCH"

@export_category("LIGHT OBJECTS")
@export var lights_group : Array[OmniLight3D] # Node reference of the light
@export var light_energy : float = 1.0 # Energy of each light objects

@onready var audio_player := $AudioStreamPlayer3D # Reference to the audio player 3d

var is_switch_on := true # Tracks the current state of the switch

func _on_interacted(body: Variant) -> void:
	toggle_light()
	
func toggle_light():
	play_audio() # Plays the audio clip in the audio stream player
	
	 # Only call this function when theres light object in the array
	if lights_group.size() <= 0 : return
	
	if is_switch_on:
		set_light_state(0)
	else:
		set_light_state(light_energy)
		
	is_switch_on = !is_switch_on # Update the switch state
	
func set_light_state(energy_amount : float):
	# Loop though lights array and modified each energy
	for lights in lights_group:
		if lights != null:
			lights.light_energy = energy_amount
			
func play_audio():
	audio_player.play()
