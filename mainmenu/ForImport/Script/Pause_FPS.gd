extends Control

@onready var settings_node = $"../../../../.."  #calling the parent node
@export var Fps: ColorRect #calling the FPS UI IN the Scene
@onready var Bt_txt = $HBoxContainer/Button as Button # calling the button in the scene
var save_path: String = "user://settings.json" #path file for saving

var FPSOn: bool = false #flag for turning on and off the fps UI

func _ready() -> void:
	load_settings() #loading the saved data
	update_button_text() #update the text base to the saved data 
	settings_node.set_fps_ui(FPSOn)  # Apply FPS UI setting on load

func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF"  #update the text based if its on or off

func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	save_settings() #save settings
	update_button_text() #update the text based if its on or off
	settings_node.set_fps_ui(FPSOn)  # Apply the new setting


#save function
func save_settings() -> void:
	var settings_data: Dictionary = {}
	
	var file = FileAccess
	# Load existing settings if the file exists
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(json_data)
		if parsed is Dictionary:
			settings_data = parsed  # Keep previous settings

	# Update only the FPS setting
	settings_data["FPSOn1"] = FPSOn  

	# Save the updated settings back to file
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings_data, "\t"))  # Pretty format JSON
	file.close()


#loading function
func load_settings() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if the file doesn't exist

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		FPSOn = parsed.get("FPSOn1", false)  # Default to false if not found
	
	# Apply FPS UI setting after loading
	settings_node.set_fps_ui(FPSOn)
