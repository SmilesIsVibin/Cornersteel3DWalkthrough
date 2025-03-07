extends Control

@onready var settings = $"../../../../.." # Adjust based on your scene tree (this is the settings node)
@onready var Bt_txt = $HBoxContainer/Button as Button # Getting the button used in the scene/function
var save_path: String = "user://settings.json"  #Set a file destination for saving 

var FPSOn: bool = false #used as flag to recognize wheter the fps UI is on or off


#this function called every start of the scene
func _ready() -> void:
	load_settings() # This load the save file
	update_button_text() #Updates the button text

#Updating the button text ON - OFF
func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF" #changing the label that is child to button

# This function apply when the button pressed
func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	save_settings() # Saving the data after pressing the button
	update_button_text() # Updates the button text
	settings.set_fps_ui(FPSOn) #change the flag in the settings (this function is connected to the other script it chnages boolean to turn on the Fps UI )

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

#update or change the default settings after loading the file
	update_button_text()
	settings.set_fps_ui(FPSOn)
