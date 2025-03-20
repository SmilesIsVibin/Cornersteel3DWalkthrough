extends Control

@onready var button_scene = preload("res://Scenes/action.tscn") #INstance he button in the scene
@onready var action_list = $MarginContainer/VBoxContainer/ScrollContainer/Action #Get the location where to instantiate the buttons

var is_remapping = false
var action_to_remap = null
var remapping_button = null

#call the var in the input map in the project
var input_actions = {
	"move_forward": "Forward",
	"move_backward": "Backwards",
	"move_left": "Left",
	"move_right": "Right",
	"jump_key": "Jump", 
}

var SAVE_PATH = "user://key_bindings.json"  # Path for saving the key bindings

#Calls at the Start 
func _ready() -> void:
	load_key_bindings()
	_create_action_list()

#------------------------------- Setting Up and changing the Input map -------------------------------------

#set the action list that is being called in the var
func _create_action_list() -> void:
	for item in action_list.get_children():
		item.queue_free()

	# Create action buttons based on current key bindings
	for action in input_actions:
		var button = button_scene.instantiate()
		var _Start_Label = button.find_child("LABEL_Action")
		var action_label = button.find_child("Label2")
		
		_Start_Label.text = input_actions[action]  # Set the action name
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			action_label.text = events[0].as_text().trim_suffix(" (Physical)")  # Set the key binding label
		else:
			action_label.text = ""  # No key bound yet

		# Add button to the action list in the UI
		action_list.add_child(button)

		# Set callback for when the button is pressed
		var button_pressed = button.find_child("Input")
		button_pressed.pressed.connect(on_input_button_pressed.bind(button, action))
#Handles the function if the player press the input button
func on_input_button_pressed(button, action) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Label2").text = "Press key to bind....."
#Handles the input that player preference
func _input(event):
	if is_remapping:
		if (
			event is InputEventKey || 
			(event is InputEventMouseButton && event.pressed)
		):
			# Erase any previous events and add the new one
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)

			# Update the button text with the new key binding
			_update_action_list(remapping_button, event)

			# Save the settings after remapping
			save_key_bindings()

			is_remapping = false
			action_to_remap = null
			remapping_button = null

			accept_event()
#change the text in the keybinds
func _update_action_list(button, event):
	button.find_child("Label2").text = event.as_text().trim_suffix(" (Physical)")
#reset the key bind to default 
func _on_button_pressed() -> void:
	InputMap.load_from_project_settings()
	save_key_bindings()
	_create_action_list()

#------------------------------- Saving --------------------------------------------------
# Save the current key bindings to a file
func save_key_bindings() -> void:
	var key_bindings_data: Dictionary = {}

	# Store the current key bindings
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			key_bindings_data[action] = events[0].as_text().trim_suffix(" (Physical)")
		else:
			key_bindings_data[action] = ""  # No key bound yet

	# Save the data to a JSON file
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(key_bindings_data, "\t"))  # Pretty print JSON
		file.close()
		print("Key bindings saved successfully.")
	else:
		print("Failed to save key bindings: ", FileAccess.get_open_error())
# Load saved key bindings from the file
func load_key_bindings() -> void:
	# Load the saved settings if the file exists
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_data = file.get_as_text()
			file.close()

			var parsed_data = JSON.parse_string(json_data)
			if parsed_data is Dictionary:
				# Load key bindings from the file
				for action in parsed_data:
					var binding = parsed_data[action]
					if binding != "":
						InputMap.action_erase_events(action)
						var key_event = InputEventKey.new()
						key_event.keycode = OS.find_keycode_from_string(binding)  # Convert string to keycode
						InputMap.action_add_event(action, key_event)
				print("Key bindings loaded successfully.")
			else:
				print("Failed to load key bindings, invalid format.")
		else:
			print("Failed to open key bindings file for reading: ", FileAccess.get_open_error())
	else:
		print("No key bindings file found, using default bindings.")
