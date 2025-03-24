class_name AudioSave
extends Control

@onready var name_ = $HBoxContainer/Label as Label #Name uses in the Scene
@onready var slider_ = $HBoxContainer/HSlider as HSlider #get Slider in the Scene
@onready var muteBTN = $HBoxContainer/Button as Button
@export_enum("Master", "MUSIC", "SFX") var bus_name: String #Getting Name of the Bus

var bus_index: int = 0 #Bus Count
const SAVE_PATH = "user://settings.json" #Saving Path
var saved_value

#Star Function
func _ready() -> void:
	get_busname()
	set_name_Label()
	load_audio_settings()  # Load saved settings
	set_slider()
	slider_.value_changed.connect(on_changed)

#Setting Up Name
func set_name_Label() -> void:
	name_.text = str(bus_name) + " Volume"


#Getting the Set bus name
func get_busname() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

#Set Slider base on the bus volume
func set_slider() -> void:
	slider_.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

#When the slider change it changes the bus volume
func on_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	if value > 0:
		muteBTN.text = "Mute"
	else:
		muteBTN.text = "Unmute"
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
			saved_value = parsed_data[bus_name]
			slider_.value = saved_value
			if slider_.value > 0:
				muteBTN.text = "Mute"
			else:
				muteBTN.text = "Unmute"
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(saved_value))

func _on_button_pressed() -> void:
	if slider_.value == 0:
		muteBTN.text = "Mute"
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(1))
		slider_.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	else:
		muteBTN.text = "Unmute"
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(0))
		slider_.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
