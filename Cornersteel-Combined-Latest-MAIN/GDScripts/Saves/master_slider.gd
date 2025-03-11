
class_name AudioSave
extends Control

@onready var name_ = $HBoxContainer/Label as Label
@onready var slider_ = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "MUSIC", "SFX") var bus_name: String

var bus_index: int = 0
const SAVE_PATH = "user://settings.json"

func _ready() -> void:
	get_busname()
	set_name_Label()
	load_audio_settings()  # Load saved settings
	set_slider()
	slider_.value_changed.connect(on_changed)

func set_name_Label() -> void:
	name_.text = str(bus_name) + " Volume"
	
func get_busname() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider() -> void:
	slider_.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func on_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	save_audio_settings()  # Save the new value when changed

# Save volume settings to a JSON file
func save_audio_settings() -> void:
	var volume_data: Dictionary = {}
	var file: FileAccess
	# Load existing settings if the file exists
	if FileAccess.file_exists(SAVE_PATH):
		file = FileAccess.open(SAVE_PATH,FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()
		var parsed_data = JSON.parse_string(json_data)
		if parsed_data is Dictionary:
			volume_data = parsed_data  # Keep existing settings

	# Store the new volume value
	volume_data[bus_name] = slider_.value  

	# Save back to file
	file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(volume_data, "\t"))  # Pretty print JSON
	file.close()

# Load saved volume settings
func load_audio_settings() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()

		var parsed_data = JSON.parse_string(json_data)
		if parsed_data is Dictionary and bus_name in parsed_data:
			var saved_value = parsed_data[bus_name]
			slider_.value = saved_value
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(saved_value))
