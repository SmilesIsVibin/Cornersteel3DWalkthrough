extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERFACE SETTINGS")
@export var prompt_message = "SWITCH"

@export_category("LIGHT OBJECTS")
@export var lights_group : Array[OmniLight3D] # Node reference of the light
@export var light_energy : float = 1.0 # Energy of each light objects

@onready var audio_player := $AudioStreamPlayer3D # Reference to the audio player 3d

var is_switch_on := true # Tracks the current state of the switch

func _on_interacted(body: Variant) -> void:
	Switch_ON_OFF()
	play_audio()

func _process(delta: float) -> void:
	if is_switch_on:
		toggle_light()
	else:
		toggle_light()

func toggle_light():
	 # Plays the audio clip in the audio stream player
	
	 # Only call this function when theres light object in the array
	if lights_group.size() <= 0 : return
	
	if is_switch_on:
		set_light_state(0)
	else:
		set_light_state(light_energy)
		
	 # Update the switch state

func Switch_ON_OFF() -> void:
	is_switch_on = !is_switch_on
	print(Clock.Lights_Switch)
	
	if is_switch_on:
		Clock.Lights_Switch += 1
	else:
		Clock.Lights_Switch -= 1
	
	if Clock.Lights_Switch == 3:
		await get_tree().create_timer(1).timeout
		delay()
	elif Clock.Lights_Switch == 0:
		await get_tree().create_timer(1).timeout
		delay()

func delay() -> void:
	Clock.counterOfflight()
func set_light_state(energy_amount : float):
	# Loop though lights array and modified each energy
	for lights in lights_group:
		if lights != null:
			lights.light_energy = energy_amount
			
func play_audio():
	audio_player.play()
