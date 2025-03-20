class_name OptionMenu
extends Control

@onready var exit =$MarginContainer/VBoxContainer/Button #Button Location
var FPSUI : bool = false # Flag For the FPS UI
signal exit_settings #Signal that other script can recieve

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.button_down.connect(_on_exit_pressed)
	set_process(false)


#Handles Sending Signal if the player Press the Exit Button
func _on_exit_pressed() -> void:
	exit_settings.emit()
	set_process(false)
	print("Exit")
