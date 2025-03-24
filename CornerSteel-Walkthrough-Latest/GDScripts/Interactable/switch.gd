extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERFACE SETTINGS")
@export var prompt_message = "SWITCH"
@export var toggle_delat = 1.0

@export_category("LIGHT OBJECTS")
@export var lights_group : Array[OmniLight3D] # Node reference of the light
@export var light_energy : float = 1.0 # Energy of each light objects

@onready var audio_player := $AudioStreamPlayer3D # Reference to the audio player 3d
var is_toggling: bool = false  # Prevents rapid toggling
var can_interact : bool = true # Add Delay before toggling again
var is_switch_on := false # Tracks the current state of the switch

func _ready() -> void:
	toggle_light()
	prompt_message = ("SWITCH" + "\n[" + "E" + "]")

func _on_interacted(body: Variant) -> void:
	play_audio()
	Switch_ON_OFF()

func _process(delta: float) -> void:
		toggle_light()
		

func toggle_light():
	 # Only call this function when theres light object in the array
	if lights_group.size() <= 0 : return
	
	if is_switch_on:
		set_light_state(light_energy)
	else:
		set_light_state(0)
		
	 # Update the switch state

func Switch_ON_OFF() -> void:
	if is_toggling or not can_interact:
		return  # Prevent spamming and disable interaction during cooldown
		
	update_prompt_text("")
	enable_interaction(false)
	
	# Update the switch state
	is_switch_on = !is_switch_on

	# Wait for the delay before allowing interaction again
	await get_tree().create_timer(toggle_delat).timeout
	enable_interaction(true)
	update_prompt_text("SWITCH" + "\n[" + "E" + "]")
	
	if is_switch_on:
		Clock.Lights_Switch += 1
	else:
		Clock.Lights_Switch -= 1
	
	if Clock.Lights_Switch == 3:
		await get_tree().create_timer(1).timeout
		Clock.counterONlight()
	elif Clock.Lights_Switch == 0:
		await get_tree().create_timer(1).timeout
		Clock.counterOfflight()
	
func set_light_state(energy_amount : float):
	# Loop though lights array and modified each energy
	for lights in lights_group:
		if lights != null:
			lights.light_energy = energy_amount
			
func play_audio():
	# Self explanatory
	if can_interact:
		audio_player.play()
		
func enable_interaction(enable : bool):
	# Update toggle can interact state based on bool parameter
	is_toggling = !enable
	can_interact = enable
	
func update_prompt_text(text : String):
	# Update prompt text based on string parameter
	prompt_message = text
	
