extends Control

var FPSUI: bool = false
@export var Fps: ColorRect

func _process(_delta: float) -> void:
	_processME()

# Function to modify FPSUI from FPSToggle
func set_fps_ui(value: bool) -> void:
	FPSUI = value
	print("FPSUI set to:", FPSUI)

func _processME() -> void:
	if FPSUI:
		Fps.visible = true  # Fixed typo here
	else:
		Fps.visible = false
