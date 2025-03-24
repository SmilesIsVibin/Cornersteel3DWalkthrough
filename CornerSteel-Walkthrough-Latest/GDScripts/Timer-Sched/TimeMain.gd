extends Control

@onready var BTN_TXT = $HBoxContainer/Plus

func _ready() -> void:
	btnTXT()
	
func _process(_delta: float) -> void:
	btnTXT()

func _on_plus_pressed() -> void:
	if Clock.UI_Time:
		Clock.UI_Time = false
	else:
		Clock.UI_Time = true
		
	print(Clock.UI_Time)


func btnTXT() -> void:
	BTN_TXT.text = "ON" if Clock.UI_Time else "OFF"
