extends Control

@onready var Option_Button = $HBoxContainer/OptionButton as OptionButton

const WindowMode_Array: Array[String] = [
	"Full-Screen",
	"Windowed",
	"Borderless",
	"Borderless Full-screen"
]

var save_path: String = "user://settings.json"
var current_window_mode: int = 0  # Default to Full-Screen

func _ready() -> void:
	add_Items()
	load_window_mode()  # Load and apply saved window mode
	Option_Button.item_selected.connect(on_window)

func add_Items() -> void:
	for window_mode in WindowMode_Array:
		Option_Button.add_item(window_mode)

func on_window(index: int) -> void:
	current_window_mode = index  # Store the selected mode

	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Borderless Full-Screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

	Option_Button.select(index)  # Update button selection
	save_window_mode()  # Save the selection

func save_window_mode() -> void:
	var settings: Dictionary = {}
	var file = FileAccess
	# Load existing settings to avoid overwriting other values
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(json_data)
		if parsed is Dictionary:
			settings = parsed  # Keep old settings

	settings["WindowMode"] = current_window_mode  # Update window mode

	# Save the updated settings
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))  # Pretty format JSON
	file.close()

func load_window_mode() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if the file doesn't exist

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		current_window_mode = parsed.get("WindowMode", 0)  # Default to Full-Screen

	Option_Button.select(current_window_mode)  # Ensure button shows saved mode
	on_window(current_window_mode)  # Apply the saved window mode
