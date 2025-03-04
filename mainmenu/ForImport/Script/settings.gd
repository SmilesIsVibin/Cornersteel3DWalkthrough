extends Control

@onready var MainMenu = get_node("/root/MainMenu")  # Adjust the path based on your scene hierarchy
var FPSUI: bool = false

# Function to modify FPSUI from FPSToggle
func set_fps_ui(value: bool) -> void:
	FPSUI = value
	print("FPSUI set to:", FPSUI)

func _process(_delta: float) -> void:
	UI_Set_MainMenu()

# Function to interact with MainMenu
func UI_Set_MainMenu() -> void:
	if MainMenu:
		MainMenu.set_fps_ui1(FPSUI)
	else:
		print("Error: MainMenu node not found!")
