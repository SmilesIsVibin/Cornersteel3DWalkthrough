extends Control

@onready var settings = $"../../../../.." # Adjust based on your scene tree
@export var Fps: ColorRect
@onready var Bt_txt = $HBoxContainer/Button as Button
var save_path: String = "user://settings.json"

var FPSOn: bool = false

func _ready() -> void:
	load_settings()
	update_button_text()

func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF"

func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	save_settings()
	update_button_text()
	settings.set_fps_ui(FPSOn)

func save_settings() -> void:
	var settings_dict: Dictionary = {}  # Create a separate dictionary for saving
	
	var file = FileAccess
	# Load existing settings if the file exists
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(json_data)
		if parsed is Dictionary:
			settings_dict = parsed  # Keep previous settings

	# Update only the FPSOn value
	settings_dict["FPSOn1"] = FPSOn  

	# Save the updated settings back to file
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings_dict, "\t"))  # Pretty format JSON
	file.close()

func load_settings() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if the file doesn't exist

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		FPSOn = parsed.get("FPSOn1", true)

	update_button_text()
	settings.set_fps_ui(FPSOn)
