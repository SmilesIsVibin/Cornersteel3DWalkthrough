
class_name AudioSave
extends Control

@onready var name_ = $HBoxContainer/Label as Label  #calling the label in the scene 
@onready var slider_ = $HBoxContainer/HSlider as HSlider # calling the slider in the scene

@export_enum("Master", "MUSIC", "SFX") var bus_name: String  #exporting and setting the buz name using the enum 

var bus_index: int = 0 #bus name counter 
const SAVE_PATH = "user://settings.json" #path file for saving

func _ready() -> void:
	get_busname() # Get all the bus name SETS in the audio tab in the project
	set_name_Label() # Setting the name of the bus in the label
	load_audio_settings()  # Load saved settings
	set_slider() # sets the slider value
	slider_.value_changed.connect(on_changed) #connects the slider in the on_changed function

func set_name_Label() -> void:
	name_.text = str(bus_name) + " Volume" #setting the name of bus base on the bus_name
	
func get_busname() -> void:
	bus_index = AudioServer.get_bus_index(bus_name) #gets how many bus name in the audio server

func set_slider() -> void:
	slider_.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) #setting the value of the slider based on the bus volume in the index

func on_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value)) #change the volume of bus base on the value of the slider
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
