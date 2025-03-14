extends Control


@export var Bt_txt : Button

var FPSOn: bool = true

@onready var light2 = $"../../../../.."
#@export var light = DirectionalLight3D
var save_path: String = "user://settings.json"
#signal FPS_OFF

func _ready() -> void:
	load_settings()
	update_button_text()

func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF"
	

func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	update_button_text()
	save_settings()
	if FPSOn:
		light2._set_light_off(FPSOn)
		print("ShadowON")
	else:
		light2._set_light_off(FPSOn)
		print("ShadowOff")

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
		light2._set_light_off(FPSOn)
		print("ShadowON")
	else:
		light2._set_light_off(FPSOn)
		print("ShadowOff")
