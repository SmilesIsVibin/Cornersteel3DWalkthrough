extends Button

@export var music_Player: AudioStreamPlayer

var newTrack_click = preload("res://ForImport/SFX/button-click-289742.mp3")
var newTrack_hover = preload("res://ForImport/SFX/hover-button-287656 (mp3cut.net).mp3")

func _on_pressed() -> void:
	music_Player.stream = newTrack_click
	music_Player.play()


func _on_mouse_entered() -> void:
	music_Player.stream = newTrack_hover
	music_Player.play()
