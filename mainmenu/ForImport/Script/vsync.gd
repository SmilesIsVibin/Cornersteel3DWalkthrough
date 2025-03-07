extends Control

@export var Bt_txt: Button #calling the buttons in the scene
var FPSOn: bool = false # setting up flag for turning on or off the Vsync
var save_path: String = "user://settings.json" #path file for saving


func _ready() -> void:
	load_settings() #load the data saved
	update_button_text() #update the text based on off or on

func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF" #update the text based on off or on

func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	update_button_text() #update the text based on off or on
	save_settings() #save the data about vsync
	
	#handles turning on or off the vsync
	if FPSOn:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("FPS - 60")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("FPS + 60")


#save function
func save_settings() -> void:
	var settings: Dictionary = {}
	
	var file = FileAccess
	# Load existing settings if the file exists
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(json_data)
		if parsed is Dictionary:
			settings = parsed  # Keep previous settings

	# Update only the FPSOn value
	settings["FPSOn"] = FPSOn  

	# Save the updated settings back to file
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))  # Pretty format JSON
	file.close()

#load function
func load_settings() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if the file doesn't exist

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		FPSOn = parsed.get("FPSOn", false)  # Default to false if not found

	# Ensure the UI button updates correctly
	update_button_text()

	# Apply the saved VSync mode
	if FPSOn:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("FPS - 60 (Loaded)")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("FPS + 60 (Loaded)")
