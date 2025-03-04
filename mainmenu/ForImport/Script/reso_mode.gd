extends Control

@onready var optionButton =$HBoxContainer/OptionButton as OptionButton

const resolution_Dict : Dictionary = {
	"1152 x 648" : Vector2(1152, 648),
	"1280 x 720" : Vector2(1280, 720),
	"1920 x 1080" : Vector2(1920,1080)
}

func _ready() -> void:
	add_reso()
	optionButton.item_selected.connect(on_reso)
	

func add_reso() -> void:
	for reso in resolution_Dict:
		optionButton.add_item(reso)

func on_reso(index:int) -> void:
	DisplayServer.window_set_size(resolution_Dict.values()[index])
