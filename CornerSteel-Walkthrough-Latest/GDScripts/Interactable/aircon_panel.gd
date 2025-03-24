extends "res://GDScripts/Interactable/interactable.gd"

@export_category("AIRCON PANEL SETTINGS")
@export var prompt_message = "AIRCON PANEL" # Text to display when looking at this node
@export var cooled_temperature : float = 25.0 # Temperature when the AC is on
@export var default_temperature : float = 30.0 # Temperature when the AC is off
@export var toggle_delay: float = 1.0  # Time before allowing another toggle again

@export_category("AIRCONS")
@export var aircons : Array[StaticBody3D] # Array of aircon to turn on and off

@onready var audio_player = $AudioStreamPlayer3D  # Reference to the audio player for toggling
@onready var collision_shape = $CollisionShape3D  # Reference to the collision shape
@onready var temperature_text = $TemperatureText # Reference to the temperature text node

var current_temperature: float = 0.0 # Tracks the current temperature
var target_temperature : float = 0.0
var is_acu_off: bool = false  # Tracks if the AC control panel is off or on
var is_toggling: bool = false  # Prevents rapid toggling
var can_interact : bool = true # Add Delay before toggling again

	# ---------------------- MAIN FUNCTIONS ---------------------
func _ready() -> void:
	# Initialize temperature from the start
	initialize_temperatures()
	toggle_aircon_panel()
	# Set the prompt text in the start
	update_prompt_text("AIRCON PANEL" + "\n[" + "E" + "]")
	
func _process(delta: float) -> void:
	update_temperature_text(delta)
	
func _on_interacted(body: Variant) -> void:
	new_ac_state()
	play_audio()
	interactio_mod()
	toggle_all_aircons(is_acu_off)
	toggle_aircon_panel()

	# ---------------------- AIRCON RELATED FUNCTIONS ---------------------
func toggle_aircon_panel():
	update_current_state()

func new_call():
	toggle_all_aircons(is_acu_off)
	toggle_aircon_panel()

func interactio_mod() -> void:
	if is_toggling or not can_interact:
		return  # Prevent spamming and disable interaction during cooldown
	enable_interaction(false)
	update_prompt_text("")
	await get_tree().create_timer(toggle_delay).timeout
	enable_interaction(true)
	update_prompt_text("AIRCON PANEL" + "\n[" + "E" + "]")
func update_temperature_text(delta):
	# Smoothly transition between 25 to 30C
	current_temperature = lerp(current_temperature, target_temperature, 3.0 * delta)
	
	# Convert the current tempertaure into interger and update the label
	var round_current_temp = int(round(current_temperature))
	temperature_text.text = str(round_current_temp) + "\u00B0C"
	
func initialize_temperatures():
	# Set the current and target temperature value
	current_temperature = default_temperature
	target_temperature = current_temperature
	
	# Make sure that the AC units is on by default
	is_acu_off = false
	

	# ---------------------- UTILITY FUNCTIONS ---------------------
func enable_interaction(enable : bool):
	is_toggling = !enable
	can_interact = enable
	
func update_current_state():
	# Update target temperature value based on condition
	if is_acu_off:
		target_temperature = cooled_temperature
	else:
		target_temperature = default_temperature
	
func new_ac_state() -> void:
	is_acu_off = !is_acu_off
	print(Clock.ACSwitch)
	if is_acu_off:
		Clock.ACSwitch += 1
	else:
		Clock.ACSwitch -= 1
	if Clock.ACSwitch == 3:
		await get_tree().create_timer(1).timeout
		interactio_mod()
		Clock.counterOn()
	elif Clock.ACSwitch == 0:
		await get_tree().create_timer(1).timeout
		interactio_mod()
		Clock.counterOff()

func update_prompt_text(text : String):
	prompt_message = text
	
func toggle_all_aircons(state : bool):
	# If the array of aircon has empty, do nothing
	if aircons.size() <= 0: return
	
	# Loop through array and set its state
	for aircon in aircons:
		if aircon.has_method("set_aircon_state"):
			aircon.set_aircon_state(state)
			
func play_audio():
	# Self explanatory
	if can_interact:
		audio_player.play()
