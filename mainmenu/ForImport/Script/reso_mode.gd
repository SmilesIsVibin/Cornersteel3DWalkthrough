extends Control

@onready var optionButton = $HBoxContainer/OptionButton as OptionButton

const resolution_Dict: Dictionary = {
	"1152 x 648": Vector2(1152, 648),
	"1280 x 720": Vector2(1280, 720),
	"1920 x 1080": Vector2(1920, 1080)
}

var save_path: String = "user://settings.json"
var current_resolution: String = "1280 x 720"  # Default resolution

func _ready() -> void:
	load_resolution()  # Load saved resolution
	add_reso() #set up the preffered resolution
	optionButton.item_selected.connect(on_reso) #connect the button to the on_reso function

	# Set the UI selection to match the loaded resolution
	if current_resolution in resolution_Dict:
		optionButton.select(resolution_Dict.keys().find(current_resolution))

func add_reso() -> void:
	for reso in resolution_Dict:
		optionButton.add_item(reso)

func on_reso(index: int) -> void:
	current_resolution = resolution_Dict.keys()[index]  # Get resolution name
	DisplayServer.window_set_size(resolution_Dict[current_resolution])
	save_resolution()  # Save new resolution

#saving function
func save_resolution() -> void:
	var settings: Dictionary = {}
	var file = FileAccess
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()
		
		var parsed = JSON.parse_string(json_data)
		if parsed is Dictionary:
			settings = parsed  # Keep previous settings

	# Save the selected resolution
	settings["Resolution"] = current_resolution  

	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))  # Save as formatted JSON
	file.close()

#loading function
func load_resolution() -> void:
	if not FileAccess.file_exists(save_path):
		return  # Skip if no save file exists

	var file = FileAccess.open(save_path, FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(json_data)
	if parsed is Dictionary:
		current_resolution = parsed.get("Resolution", "1280 x 720")  # Default if not found

	# Apply the loaded resolution
	if current_resolution in resolution_Dict:
		DisplayServer.window_set_size(resolution_Dict[current_resolution])
