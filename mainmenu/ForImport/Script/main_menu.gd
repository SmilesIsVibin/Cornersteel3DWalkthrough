extends Control

@onready var option = $MainSettings as OptionMenu #Calling the script in Settings menu
@onready var MainMenu = $VBoxContainer #Gettig the Container in the scene where the buttons are 
@export var UIFPS : ColorRect #Gettings the FPS UI 
var FPSUI2: bool #Flag for Turning on and off of UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_process_UI() # checks if the UI is turn on or off
	option.exit_settings.connect(_on_exit_settings) #This recieve the signal comes from the settings script

# This function is assign for changing scene
func _on_Start_pressed() -> void:
	await get_tree().create_timer(0.3).timeout # delay the change scene
	get_tree().change_scene_to_file("res://ForImport/SCENE/Level1.tscn") #scence handler


func _process(_delta: float) -> void:
	_process_UI() # checks every frame if the fps ui is on or off 

#Use for checking if the player turn or off the UI
func _process_UI() -> void:
	if FPSUI2:
		UIFPS.visible = true #setting the UI to visible
	else:
		UIFPS.visible = false #setting the UI to Invisible

#This function is assign to turn off the node where the main menu and turn on where the settings node are
func _on_settings_pressed() -> void:
	MainMenu.visible = false #Sets the mainmenu node to invisble
	option.set_process(true) # Enable the node's _process function to run each frame
	option.visible = true #sets the settings node to visible 

#This function is assign to turn "ON" the node where the main menu and turn "OFF" where the settings node are
func _on_exit_settings() -> void:
	MainMenu.visible = true
	option.visible = false

#This function close the game
func _on_Quit_pressed() -> void:
	await get_tree().create_timer(0.3).timeout  # Wait for 1 second
	get_tree().quit()

#This handles the flag whether the player turn on or off the UI
func set_fps_ui1(value: bool) -> void:
	FPSUI2 = value
