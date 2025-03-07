extends Control

@export var Bt_txt : Button #exporting the button in the scene
@onready var light2 = $"../../../../.." #getting the node where the light sets on
var save_path: String = "user://settings.json" # path file for saving 
var FPSOn: bool = true # flag for the shadown visibility


func _ready() -> void:
	load_settings() # load the data of the shadow
	update_button_text() #Updates the text in the button

#Updates the text in the button
func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF"


func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	update_button_text() #Updates the text in the button
	save_settings() # saves the data 
	
	#this function is the responsible for turning on or off the shadow
	if FPSOn:
		light2.set_light_off(FPSOn)
	else:
		light2.set_light_off(FPSOn)

#Function for saving the data
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
	settings_data["Shadow"] = FPSOn  

	# Save the updated settings back to file
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings_data, "\t"))  # Pretty format JSON
	file.close()

#Responsible for loading the data
func load_settings() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if the file doesn't exist

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		FPSOn = parsed.get("Shadow", false)
		

#Recall the function for setting up the shadow
	if FPSOn:
		light2.set_light_off(FPSOn)
	else:
		light2.set_light_off(FPSOn)
