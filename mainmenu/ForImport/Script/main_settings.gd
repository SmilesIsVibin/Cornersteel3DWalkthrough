class_name OptionMenu
extends Control

@onready var exit =$MarginContainer/VBoxContainer/Button  #Calling the exit button in the scene
var FPSUI : bool = false # this use for flaf in the FPS UI
signal exit_settings #this use for signal where u can accept in other script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.button_down.connect(_on_exit_pressed) #Connect to other function where you send the signal
	set_process(false) #Setting off the process 

#Used for sending signal to other code after presisng the button 
func _on_exit_pressed() -> void:
	exit_settings.emit()  # Sending the signal
	set_process(false) ##Setting off the process 
	print("Exit") #Used for checking if this function is called or not
