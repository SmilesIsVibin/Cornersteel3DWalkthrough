extends Control

@export var pauseMenu: Control




func _on_button_2_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn") # Setting Up the Next Scene


func _on_button_button_down() -> void:
	pauseMenu.toggle_panel()
