extends Control

@onready var input_multi = $HBoxContainer/LineEdit
var new_value: float

func _ready() -> void:
	input_multi.text = str(Clock.time_multiplier)

func _on_line_edit_text_changed(new_text: String) -> void:
	new_value = float(new_text)


func _on_line_edit_focus_entered() -> void:
	input_multi.clear()


func _on_line_edit_text_submitted(new_text: String) -> void:
	input_multi.release_focus()
	if new_value != 0 or new_text == "0":  # valid conversion, including "0"
		input_multi.text = str(new_value)
		Clock.time_multiplier = new_value
	else:
		input_multi.text = "Input a number"
		await get_tree().create_timer(1).timeout
		input_multi.clear()
