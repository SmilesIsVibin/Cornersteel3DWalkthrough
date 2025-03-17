extends Control


@onready var B_plus = $HBoxContainer/Plus
@onready var B_minus = $HBoxContainer/Minus
@onready var label_text = $HBoxContainer/Label

@export var hrs: bool
@export var min: bool
@export var sec: bool
@export var multi: bool

func _ready() -> void:
	if hrs:
		label_text.text = "Hours"
	elif min:
		label_text.text = "Minutes"
	elif sec:
		label_text.text = "Seconds"

func _on_plus_pressed() -> void:
	if hrs:
		Clock.current_hour += 1.0
	elif min:
		Clock.current_min += 1.0
	elif sec:
		Clock.current_sec += 1.0
	elif multi: 
		Clock.time_multiplier += 10.0

func _on_minus_pressed() -> void:
	if hrs:
		Clock.current_hour -= 1.0
		if Clock.current_hour < 0:
			Clock.current_hour = 23.0
	elif min:
		Clock.current_min -= 1.0
		if Clock.current_min < 0:
			Clock.current_min = 59.0
	elif sec:
		Clock.current_sec -= 1.0
		if Clock.current_sec < 0:
			Clock.current_sec = 59.0
	elif  multi:
		Clock.time_multiplier -= 10.0
