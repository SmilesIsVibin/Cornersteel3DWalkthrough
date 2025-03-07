extends Control


@export var Bt_txt : Button # calliing the button needed in the scene
@onready var light2 = $"../../../../.." #calling the parent node 
var save_path: String = "user://settings.json" #path file for saving 
var FPSOn: bool = true #handles the turn off or on of the shadow


func _ready() -> void:
	load_settings() #load shadow
	update_button_text() #update the text based on off or on

func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF"  #update the text based on off or on
	

func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	update_button_text()  #update the text based on off or on
	save_settings() #saving data about shadow
	
	#handles turning on or off of shadow
	if FPSOn:
		light2.set_light_off(FPSOn)
	else:
		light2.set_light_off(FPSOn)

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

func load_settings() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if the file doesn't exist

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		FPSOn = parsed.get("Shadow", false)
		
	if FPSOn:
		light2.set_light_off(FPSOn)
		print("ShadowON")
	else:
		light2.set_light_off(FPSOn)
		print("ShadowOff")
