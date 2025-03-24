extends Area3D

# This script changes the room temperature based on the number of active AC units in the scene

@export_category("Temperature Settings")
@export var default_temperature: float = 30.0  # Default room temperature
@export var cooled_temperature: float = 25.0  # Temperature when AC is on

@export_category("Color Settings")
@export var warm_color = Color(1.0, 0.5, 0.3, 0.3) # Default room temperature color
@export var cool_color = Color(0.3, 0.5, 1.0, 0.3) # room temperature color when AC on

var current_temperature : float = 0.0 # Tracks the current room temperature
var target_temperature : float = 0.0 # Tracks the temperature to transition to
var is_player_inside: bool = false # Flag to check whether the player is inside area3d or not
var screen_color # Reference to the color rect node in the player node
var player # Reference to the player node

	# ----------------------MAIN FUNCTIONS ---------------------
func _ready() -> void:
	initialize_temperature() # Set temperatures
	get_player_node() # Try to get the player node
	
func _process(delta: float) -> void:
	update_temperature(delta)
	update_screen_color()

	# ----------------------TEMPERATURE RELATED FUNCTIONS ---------------------
func update_temperature(delta: float):
	target_temperature = get_average_temperature()
	current_temperature = lerp(current_temperature, target_temperature, 1.0 * delta)
	
func update_screen_color():
	var blend_factor = inverse_lerp(default_temperature, cooled_temperature, current_temperature)
	screen_color.modulate = warm_color.lerp(cool_color, blend_factor)

	# ---------------------- UTILITY FUNCTIONS ---------------------
func initialize_temperature():
	current_temperature = default_temperature
	target_temperature = current_temperature

func get_average_temperature() -> float:
	if !is_player_inside:
		return default_temperature
		
	# Create an empty list to store all AC Unit temperatures
	var temperatures = []

	for ac_unit in get_tree().get_nodes_in_group("AC_Units"):
		temperatures.append(ac_unit.current_temperature)

	if temperatures.size() > 0:
		# Calculate the average temperature of all AC Units
		var total_temperature = temperatures.reduce(func(a, b): return a + b, 0.0)
		return total_temperature / temperatures.size()

	# Ensure the function always returns a value
	return default_temperature
	
func get_player_node():
	# Try to get the player node in the scene tree
	var players = get_tree().get_nodes_in_group("Player")
	
	# If found successfull, store the color rect on in the screen color variable
	if players.is_empty(): return
	screen_color = players[0].get_node("PlayerInterface/ScreenColor")
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = true
	
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = false
