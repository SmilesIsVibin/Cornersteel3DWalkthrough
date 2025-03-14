class_name OptionMenu
extends Control

@onready var exit =$MarginContainer/VBoxContainer/Button
var FPSUI : bool = false
signal exit_settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.button_down.connect(_on_exit_pressed)
	set_process(false)

func _on_exit_pressed() -> void:
	exit_settings.emit()
	set_process(false)
	print("Exit")
