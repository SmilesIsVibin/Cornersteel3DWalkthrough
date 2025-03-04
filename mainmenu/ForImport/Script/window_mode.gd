extends Control

@onready var Option_Button = $HBoxContainer/OptionButton as OptionButton

const WindowMode_Array : Array[String] = [
	"Full-Screen",
	"Windowed",
	"Borderless",
	"Bordeless Full-screen"
] 

func _ready() -> void:
	add_Items()
	Option_Button.item_selected.connect(on_window)
	

func add_Items()-> void:
	for window_mode in WindowMode_Array:
		Option_Button.add_item(window_mode)


func on_window(index: int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1:#Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		2:#Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		3:#Borderless FS
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
