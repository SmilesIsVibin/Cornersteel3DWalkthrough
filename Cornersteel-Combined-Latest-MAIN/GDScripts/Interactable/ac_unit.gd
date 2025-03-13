extends "res://GDScripts/Interactable/interactable.gd"

@export_category("INTERFACE SETTINGS")
@export var prompt_message = "AIRCON"
@export var warm_color : Color = Color(1.0, 0.5, 0.3, 0.3) # Screen color when acu is off
@export var cool_color : Color = Color(0.3, 0.5, 1.0, 0.3) # Screen color when acu is on
@onready var temperature_text = $TemperatureText # Refernce to the temperature text node
var player # Reference to tthe player node
var screen_color # Reference to the color rect in the player node

@export_category("ACU SETTING")
@export var default_temperature : float = 30.0 # Default temparature
@export var cool_temperature : float = 25.0 # Temperature when the acu is on
@export var transition_time : float = 1.0 # How fast the transition between warm and cool temp

var target_temperature : float = 0.0 # Tracks the temperature to use
@export var current_temperature : float = 0.0 # Stacks the current temperature
var is_acu_off : bool = true # Flag to check whether the acu is on or off
var is_toggling : bool = false # Flag to check whether the temperature is transitioning or not

@onready var collision_shape3d = $CollisionShape3D # Reference to the collision shape 3d
@onready var audio_player = $AudioStreamPlayer3D # Reference to the audio player 3d

func _ready() -> void:
	get_player_node()
	initialize_Temperature()
	
func _process(delta: float) -> void:
	update_temperature(delta)
	update_screen_color()
	
func _on_interacted(body: Variant) -> void:
	toggle_aircon()

	# ----------------------TEMPERATURE RELATED FUNCTIONS ---------------------
func update_temperature(delta):
	# Smoothly transition between 25 to 30C
	current_temperature = lerp(current_temperature, target_temperature, transition_time * delta)
	
	# Convert the current tempertaure into interger
	var round_current_temp = int(round(current_temperature))
	
	# Update the temperature message
	temperature_text.text = str(round_current_temp) + "\u00B0C"
	
func initialize_Temperature():
	# Set the current and target temperature
	current_temperature = default_temperature
	target_temperature = current_temperature
	
	# Set the temperature text to default temperature amount
	temperature_text.text = str(snapped(current_temperature, 0.1)) + "'C"
	
	# Make sure that the aircon is set to off by default
	is_acu_off = true
	
func toggle_aircon():
	# Stop this function when toggling is true
	if is_toggling == true: return
	
	# Disable the collision and set toggling to true
	disable_collision(true)
	
	if is_acu_off:
		target_temperature = cool_temperature
	else:
		target_temperature = default_temperature
	
	play_audio() # Plays the audio clip in the audio stream player
	is_acu_off = !is_acu_off # Update the aircon state
	
	# Wait for 3 second before enabling the collision
	await get_tree().create_timer(3).timeout
	disable_collision(false)

	# ----------------------UTILITY FUNCTIONS ---------------------
func disable_collision(enable : bool):
	# Modify collision and toggling value based on parameter
	collision_shape3d.disabled = enable
	is_toggling = enable
	
func update_screen_color():
	# Use inverse lerp to smoothly blend color between warm and cool
	var time = inverse_lerp(30.0, 25.0, get_average_temperature())
	screen_color.modulate = warm_color.lerp(cool_color, time)
	
func get_player_node():
	# Try to get the player node in the scene
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() <= 0: return
	 
	# Get and store the screen color node in the player
	screen_color = players[0].get_node("PlayerInterface/ScreenColor")
	
func get_average_temperature():
	# Create an empty list to store all AC Units available in the scene
	var temperatures = []
	for ac_unit in get_tree().get_nodes_in_group("AC_Units"):
		# Add each AC Units current temperature to the list
		temperatures.append(ac_unit.current_temperature)
	
	if temperatures.size() > 0:
		# Calculate the average temperature of all AC Units
		var total_temperature = temperatures.reduce(func(a, b): return a + b, 0.0)
		return total_temperature / temperatures.size()
	else:
		# Otherwise return default temperature
		return default_temperature
		
func play_audio():
	audio_player.play()
