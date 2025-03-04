extends Node3D

const SaveFile = "res://SaveFile/"

var gameData = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadData()
	

func loadData() -> void:
	#var new_file = FileAccess.open("res://SaveFile/", FileAccess.READ_WRITE)
	var new_file: FileAccess
	if not new_file.file_exists(SaveFile):
		gameData = {
			"vsyncON": false,
			"displayStats": false,
			"bloomOn": false,
			"ShadowOn":false,
			"MasterVol": -10,
			"MusicVol": -10,
			"SFXVol":-10,
			"Sens": .1,
		}
		saveData()
	FileAccess.open(SaveFile,FileAccess.READ)
	gameData = new_file.get_var()
	close_file(new_file)


func saveData() -> void:
	var new_file: FileAccess
	new_file.open(SaveFile, FileAccess.WRITE)
	new_file.store_var(gameData)
	close_file(new_file)
	

func close_file(file: FileAccess):
	file = null
