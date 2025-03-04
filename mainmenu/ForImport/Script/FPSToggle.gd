extends Control

@onready var settings =  $"../../../../.." # Adjust based on your scene tree
@export var Fps: ColorRect
@onready var Bt_txt = $HBoxContainer/Button as Button

var FPSOn: bool = false
#signal FPS_OFF

func _ready() -> void:
	update_button_text()

func update_button_text() -> void:
	Bt_txt.text = "ON" if FPSOn else "OFF"

func _on_button_pressed() -> void:
	FPSOn = !FPSOn  # Toggle FPS state
	update_button_text()
	settings.set_fps_ui(FPSOn)
