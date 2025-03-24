extends Control

@onready var option = $MainSettings as OptionMenu # Settings Tab
@onready var MainMenu = $Control # Main menu tab
@export var UIFPS : ColorRect # FPS Counter UI
var FPSUI2: bool #Flag for showing FPS UI
var save_path: String = "user://settings.json" #Saving Path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_process_UI()
	option.exit_settings.connect(_on_exit_settings)
func _process(_delta: float) -> void:
	_process_UI()


#----------------------------------- Start ----------------------------------------
func _on_Start_pressed() -> void:
	await get_tree().create_timer(0.3).timeout #WAit
	get_tree().change_scene_to_file("res://Scenes/WorldScene.tscn") # Setting Up the Next Scene

#----------------------------------- Settings ----------------------------------------

#Hadles what tab to turn off when the player press settings
func _on_settings_pressed() -> void:
	MainMenu.visible = false
	option.set_process(true)
	option.visible = true
#Hadles what tab to turn off when the player exit
func _on_exit_settings() -> void:
	MainMenu.visible = true
	option.visible = false


#----------------------------------- Quit ----------------------------------------

#Handles the Quit Function
func _on_Quit_pressed() -> void:
	await get_tree().create_timer(0.3).timeout  # Wait for 1 second
	get_tree().quit() #Quit


#----------------------------------- FPS UI ----------------------------------------

#Set the value of the flag base on the value
func set_fps_ui1(value: bool) -> void:
	FPSUI2 = value
#Hadles turn off and on when the player want to see the current FPS
func _process_UI() -> void:
	if FPSUI2:
		UIFPS.visible = true
	else:
		UIFPS.visible = false
