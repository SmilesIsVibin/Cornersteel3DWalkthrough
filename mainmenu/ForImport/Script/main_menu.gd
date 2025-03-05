extends Control

@onready var option = $MainSettings as OptionMenu
@onready var MainMenu = $VBoxContainer
@export var UIFPS : ColorRect
var FPSUI2: bool 
@export var nextScene: PackedScene
var save_path: String = "user://settings.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_process_UI()
	option.exit_settings.connect(_on_exit_settings)

func _on_Start_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Test.tscn")  #"res://Test.tscn"#"res://ForImport/SCENE/Level1.tscn"

func _process(_delta: float) -> void:
	_process_UI()

func _process_UI() -> void:
	if FPSUI2:
		UIFPS.visible = true
	else:
		UIFPS.visible = false

func _on_settings_pressed() -> void:
	MainMenu.visible = false
	option.set_process(true)
	option.visible = true
	#print("setting press")

func _on_exit_settings() -> void:
	MainMenu.visible = true
	option.visible = false

func _on_Quit_pressed() -> void:
	await get_tree().create_timer(0.3).timeout  # Wait for 1 second
	get_tree().quit()
	
func set_fps_ui1(value: bool) -> void:
	FPSUI2 = value
	#print("FPSUIMain set to:", FPSUI2)
	
