extends Control

@onready var option = $MainSettings as OptionMenu
@onready var MainMenu = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option.exit_settings.connect(_on_exit_settings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_Start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMap.tscn")


func _on_settings_pressed() -> void:
	MainMenu.visible = false
	option.set_process(true)
	option.visible = true

func _on_exit_settings() -> void:
	MainMenu.visible = true
	option.visible = false

func _on_Quit_pressed() -> void:
	get_tree().quit()
